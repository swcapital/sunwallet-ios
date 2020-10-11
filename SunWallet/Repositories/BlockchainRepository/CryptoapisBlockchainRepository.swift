import Combine
import Foundation
import TrustWalletCore

struct CryptoapisBlockchainRepository: BlockchainRepository {
    enum CryptoapisError: LocalizedError {
        case emptyUTXO
        
        var errorDescription: String? {
            switch self {
            case .emptyUTXO: return "You don't have unspent transactions. Please try later"
            }
        }
    }
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }()
    
    func balance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        switch wallet.asset {
        case .btc:
            return bitcoinBalance(for: wallet)
        case .eth:
            return etheriumBalance(for: wallet)
        default:
            fatalError("Not supported")
        }
    }
    
    func send(amount: Double, from account: Account, to destination: String, privateKey: Data) -> AnyPublisher<Void, Error> {
        let wallet = account.wallet
        switch account.asset {
        case .btc:
            return sendBTC(amount: amount, from: wallet, to: destination, privateKey: privateKey)
        case .eth:
            return sendETH(amount: amount, from: wallet, to: destination, privateKey: privateKey)
        default:
            fatalError()
        }
    }
}

//MARK: - Bitcoin
extension CryptoapisBlockchainRepository {
    
    private func btcBalancePublisher(for wallet: Wallet) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(wallet.address)"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func btcTransactionsPublisher(for wallet: Wallet) -> AnyPublisher<Response<[BitcoinTransaction]>, Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(wallet.address)/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<[BitcoinTransaction]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func bitcoinBalance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = btcBalancePublisher(for: wallet)
        let transactionsPublisher = btcTransactionsPublisher(for: wallet)
        return Publishers.CombineLatest(balancePublisher, transactionsPublisher)
            .map { balanceResponse, transactionsResponse in
                let transactions = transactionsResponse.payload.map {
                    Transaction(date: $0.datetime, value: $0.amount(for: wallet.address))
                }
                let assetBalance = AssetBalance(asset: .btc, balance: balanceResponse.payload.balance.doubleValue, transactions: transactions)
                return .init(wallet: wallet, assets: [assetBalance])
            }
            .eraseToAnyPublisher()
    }
    
    private func sendBTC(amount: Double, from wallet: Wallet, to destination: String, privateKey: Data) -> AnyPublisher<Void, Error> {
        unspentBitcoinTransactions(for: wallet)
            .tryMap { utxo -> [UTXO] in
                guard utxo.count > 0 else { throw CryptoapisError.emptyUTXO }
                return utxo
            }
            .flatMap { utxo -> AnyPublisher<Void, Error> in
                let hex = self.bitcoinOutput(utxo: utxo, amount: amount, from: wallet, to: destination, privateKey: privateKey)
                return self.broadcastBitcoinTransaction(hex: hex.encoded.hexString, for: wallet)
            }
            .eraseToAnyPublisher()
    }
    
    private func bitcoinOutput(utxo: [UTXO], amount: Double, from wallet: Wallet, to destination: String, privateKey: Data) -> BitcoinSigningOutput {
        let lockScript = BitcoinScript.lockScriptForAddress(address: wallet.address, coin: .bitcoin)
        
        let transactions = unspentTransactions(for: amount, wallet: wallet, utxo: utxo, lockScript: lockScript)
        let satoshiAmount = Measurement(value: amount, unit: BitcoinUnit.bitcoin).converted(to: .satoshi).value
        
        let scriptHash = lockScript.matchPayToWitnessPublicKeyHash()!
        
        let input = BitcoinSigningInput.with {
            $0.amount = Int64(satoshiAmount)
            $0.hashType = BitcoinSigHashType.all.rawValue
            $0.toAddress = destination
            $0.changeAddress = wallet.address
            $0.byteFee = 1
            $0.privateKey = [privateKey]
            $0.utxo = transactions
            $0.scripts[scriptHash.hexString] = BitcoinScript.buildPayToPublicKeyHash(hash: scriptHash).data
        }
        
        return AnySigner.sign(input: input, coin: .bitcoin)
    }
    
    private func unspentTransactions(for amount: Double, wallet: Wallet, utxo: [UTXO], lockScript: BitcoinScript) -> [BitcoinUnspentTransaction] {
        var result: [BitcoinUnspentTransaction] = []
        var utxo = utxo.sorted(by: { $0.amount < $1.amount })
        var amount = amount
        if amount < utxo.first!.amount {
            let output = utxo.last(where: { $0.amount > amount })!
            let transaction = unspentTransaction(output: output, wallet: wallet, lockScript: lockScript)
            result = [transaction]
        } else {
            while amount > 0 {
                let index = utxo.firstIndex(where: { $0.amount < amount })!
                let output = utxo[index]
                utxo.remove(at: index)
                let transaction = unspentTransaction(output: output, wallet: wallet, lockScript: lockScript)
                result.append(transaction)
                amount -= output.amount
            }
        }
        return result
    }
    
    private func unspentTransaction(output: UTXO, wallet: Wallet, lockScript: BitcoinScript) -> BitcoinUnspentTransaction {
        let satoshiAmount = Measurement(value: output.amount, unit: BitcoinUnit.bitcoin).converted(to: .satoshi).value
        let txID = Data(hexString: output.txid)!
        return BitcoinUnspentTransaction.with {
            $0.outPoint.hash = Data(txID.reversed())
            $0.outPoint.index = UInt32(output.vout)
            $0.outPoint.sequence = UINT32_MAX
            
            $0.amount = Int64(satoshiAmount)
            $0.script = lockScript.data
        }
    }
    
    private func unspentBitcoinTransactions(for wallet: Wallet) -> AnyPublisher<[UTXO], Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(wallet.address)/unspent-transactions"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<[UTXO]>.self, decoder: decoder)
            .map { $0.payload }
            .eraseToAnyPublisher()
    }
    
    private func broadcastBitcoinTransaction(hex: String, for wallet: Wallet) -> AnyPublisher<Void, Error> {
        let endpoint = "/v1/bc/btc/mainnet/txs/send"
        print(hex)
        return dataTaskPublisher(for: endpoint, postParameters: ["hex": hex])
            .extractDataMappingError()
            .decode(type: Response<BitcoinTransactionResponse>.self, decoder: decoder)
            .map { _ in  }
            .eraseToAnyPublisher()
    }
    
    private struct BitcoinTransaction: Codable {
        let datetime: Date
        let txins: [BitcoinTransactionDetails]
        let txouts: [BitcoinTransactionDetails]
        
        func amount(for address: String) -> Double {
            var balance = 0.0
            balance -= txins.filter { $0.addresses.contains(address) }.map(\.amount.doubleValue).reduce(0, +)
            balance += txouts.filter { $0.addresses.contains(address) }.map(\.amount.doubleValue).reduce(0, +)
            return balance
        }
    }
    
    private struct BitcoinTransactionDetails: Codable {
        let amount: String
        let addresses: [String]
    }
    
    private struct BitcoinTransactionResponse: Codable {
        let txid: String
    }
}

//MARK: - Etherium
extension CryptoapisBlockchainRepository {
    
    private func ethBalancePublisher(for wallet: Wallet) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(wallet.address)"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func ethTransactionsPublisher(for wallet: Wallet) -> AnyPublisher<Response<[EtheriumTransaction]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(wallet.address)/basic/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<[EtheriumTransaction]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func etheriumBalance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = ethBalancePublisher(for: wallet)
        let transactionsPublisher = ethTransactionsPublisher(for: wallet)
        let erc20Publisher = erc20WalletBalancePublisher(for: wallet)
        
        return Publishers.CombineLatest3(balancePublisher, transactionsPublisher, erc20Publisher)
            .map { balanceResponse, transactionsResponse, erc20 in
                let transactions = transactionsResponse.payload.map { Transaction(date: $0.datetime, value: $0.amount.doubleValue) }
                let assetBalance = AssetBalance(asset: .eth, balance: balanceResponse.payload.balance.doubleValue, transactions: transactions)
                return .init(wallet: wallet, assets: [assetBalance] + erc20.assets)
            }
            .eraseToAnyPublisher()
    }
    
    private func sendETH(amount: Double, from wallet: Wallet, to destination: String, privateKey: Data) -> AnyPublisher<Void, Error> {
        etheriumNonce(for: wallet)
            .flatMap { nonce -> AnyPublisher<Void, Error> in
                let output = etheriumOutput(amount: amount, nonce: nonce + 1, to: destination, privateKey: privateKey)
                return self.broadcastEtheriumTransaction(hex: output.encoded.hexString)
            }
            .eraseToAnyPublisher()
    }
    
    private func etheriumNonce(for wallet: Wallet) -> AnyPublisher<Int, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(wallet.address)/nonce"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<NonceResponse>.self, decoder: decoder)
            .map { $0.payload.nonce }
            .eraseToAnyPublisher()
    }
    
    private func etheriumOutput(amount: Double, nonce: Int, to destination: String, privateKey: Data) -> EthereumSigningOutput {
        let weiAmount = Measurement(value: amount, unit: EtheriumUnit.etherium).converted(to: .wei).value
        
        let signerInput = EthereumSigningInput.with {
            $0.chainID = 1.hexData
            $0.nonce = nonce.hexData
            $0.gasPrice = 3600000000.hexData
            $0.gasLimit = 21000.hexData
            $0.toAddress = destination
            $0.amount = Int(weiAmount).hexData
            $0.privateKey = privateKey
        }
        return AnySigner.sign(input: signerInput, coin: .ethereum)
    }
    
    private func broadcastEtheriumTransaction(hex: String) -> AnyPublisher<Void, Error> {
        let endpoint = "/v1/bc/eth/mainnet/txs/push"
        return dataTaskPublisher(for: endpoint, postParameters: ["hex": "0x" + hex])
            .extractDataMappingError()
            .decode(type: Response<EtheriumTransactionResponse>.self, decoder: decoder)
            .map { print($0.payload.hex)  }
            .eraseToAnyPublisher()
    }
    
    private struct EtheriumTransaction: Codable {
        let amount: String
        let datetime: Date
    }
    
    private struct EtheriumTransactionResponse: Codable {
        let hex: String
    }
    
    private struct NonceResponse: Codable {
        let nonce: Int
    }
}

//MARK: - ERC-20
extension CryptoapisBlockchainRepository {
    
    private func erc20BalancePublisher(for wallet: Wallet) -> AnyPublisher<Response<[TokenBalance]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(wallet.address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenBalance]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func erc20TransfersPublisher(for wallet: Wallet) -> AnyPublisher<Response<[TokenTransfer]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(wallet.address)/transfers"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenTransfer]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func erc20WalletBalancePublisher(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = erc20BalancePublisher(for: wallet)
        let transfersPublisher = erc20TransfersPublisher(for: wallet)
        
        return Publishers.CombineLatest(balancePublisher, transfersPublisher)
            .map { balanceResponse, transfersResponse in
                
                let assets = balanceResponse.payload.map { balance -> AssetBalance in
                    let transactions = transfersResponse.payload
                        .filter { $0.symbol == balance.symbol }
                        .map { Transaction(date: $0.datetime, value: $0.value.doubleValue) }
                    return AssetBalance(asset: balance.symbol, balance: balance.balance.doubleValue, transactions: transactions)
                }
                return .init(wallet: wallet, assets: assets)
            }
            .eraseToAnyPublisher()
    }
    
    private struct TokenBalance: Codable {
        let balance: String
        let symbol: Asset
    }
    
    private struct TokenTransfer: Codable {
        let value: String
        let datetime: Date
        let symbol: Asset
    }
}

// MARK:- Common
extension CryptoapisBlockchainRepository {
    
    private func dataTaskPublisher(for endpoint: String, postParameters: [String: Any]? = nil) -> URLSession.DataTaskPublisher {
        let host = "https://api.cryptoapis.io"
        let token = "22bfb126c375c756d0b85ae3d9ab6b398bd114b7"
        let url = URL(string: "\(host)/\(endpoint)")!
        var request = URLRequest(url: url)
        
        if let parameters = postParameters {
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        request.addValue(token, forHTTPHeaderField: "X-API-Key")
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    private struct Response<T: Codable>: Codable {
        let payload: T
    }
    
    private struct Balance: Codable {
        let balance: String
    }
}

private struct CryptoapisErrorResponse: Codable {
    struct Meta: Codable {
        let error: CryptoapisError
    }
    struct CryptoapisError: LocalizedError, Codable {
        let code: Int
        let message: String
        
        var errorDescription: String? { message }
    }
    
    let meta: Meta
}

private extension URLSession.DataTaskPublisher {
    
    func extractDataMappingError() -> Publishers.MapError<Publishers.TryMap<URLSession.DataTaskPublisher, Data>, Error> {
        extractData().mapError { error -> Error in
            guard let data = (error as? HTTPError)?.data else { return error }
            do {
                let error = try JSONDecoder().decode(CryptoapisErrorResponse.self, from: data).meta.error
                return error
            } catch {
                return error
            }
        }
    }
}

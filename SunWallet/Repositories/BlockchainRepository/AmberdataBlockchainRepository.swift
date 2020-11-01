import Combine
import Foundation
import WalletCore
import MagicSDK_Web3

private let host = "https://web3api.io/api/v2"
let web3 = Web3(rpcURL: "https://mainnet.infura.io/" + Keys.infuraKey)

struct AmberdataBlockchainRepository: BlockchainRepository {
    enum AmberdataError: LocalizedError {
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
        case .eth:
            return ethereumBalance(for: wallet)
        default:
            fatalError("Not supported")
        }
    }
    
    func send(amount: Double, from account: Account, to destination: String, privateKey: Data) -> AnyPublisher<Void, Error> {
        let wallet = account.wallet
        switch account.asset {
        case .eth:
            return sendETH(amount: amount, from: wallet, to: destination, privateKey: privateKey)
        default:
            fatalError()
        }
    }
    
}

//MARK: - Ethereum
extension AmberdataBlockchainRepository {
    
    private func ethBalancePublisher(for wallet: Wallet) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "addresses/\(wallet.address)/account-balances/historical?page=0&size=1000"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func ethTransactionsPublisher(for wallet: Wallet) -> AnyPublisher<Response<[EthereumTransaction]>, Error> {
        print(wallet.address)
        let endpoint = "addresses/\(wallet.address)/transactions?page=0&size=1000"
        return dataTaskPublisher(for: endpoint)
            .extractDataMappingError()
            .decode(type: Response<[EthereumTransaction]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func ethereumBalance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
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
    
    
    private struct EthereumTransaction: Codable {
        let amount: String
        let datetime: Date
    }
    
    private struct EthereumTransactionResponse: Codable {
        let hex: String
    }
}

//MARK: - ERC-20
extension AmberdataBlockchainRepository {
    
    private func erc20BalancePublisher(for wallet: Wallet) -> AnyPublisher<Response<[TokenBalance]>, Error> {
        let endpoint = "addresses/\(wallet.address)/token-balances/historical?page=0&size=1000"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenBalance]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func erc20TransfersPublisher(for wallet: Wallet) -> AnyPublisher<Response<[TokenTransfer]>, Error> {
        let endpoint = "addresses/\(wallet.address)/token-transfers?page=0&size=1000"
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

//MARK: - Web3
extension AmberdataBlockchainRepository {
    private func sendETH(amount: Double, from wallet: Wallet, to destination: String, privateKey: Data) -> AnyPublisher<Void, Error> {
            ethereumNonce(for: wallet)
                .flatMap { nonce -> AnyPublisher<Void, Error> in
                    let output = ethereumOutput(amount: amount, nonce: nonce + 1, to: destination, privateKey: privateKey)
                    return self.broadcastEthereumTransaction(hex: output.encoded.hexString)
                }
                .eraseToAnyPublisher()
        }
    
    private func broadcastEthereumTransaction(hex: String) -> AnyPublisher<Void, Error> {
            let endpoint = "/v1/bc/eth/mainnet/txs/push"
            return dataTaskPublisher(for: endpoint, postParameters: ["hex": "0x" + hex])
                .extractDataMappingError()
                .decode(type: Response<EthereumTransactionResponse>.self, decoder: decoder)
                .map { print($0.payload.hex)  }
                .eraseToAnyPublisher()
        }
    
    private func ethereumNonce(for wallet: Wallet) -> AnyPublisher<Int, Error> {
            let endpoint = "/v1/bc/eth/mainnet/address/\(wallet.address)/nonce"
            return dataTaskPublisher(for: endpoint)
                .extractDataMappingError()
                .decode(type: Response<NonceResponse>.self, decoder: decoder)
                .map { $0.payload.nonce }
                .eraseToAnyPublisher()
        }
        
    private func ethereumOutput(amount: Double, nonce: Int, to destination: String, privateKey: Data) -> EthereumSigningOutput {
            let weiAmount = Measurement(value: amount, unit: EthereumUnit.ethereum).converted(to: .wei).value
            
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
    

        
        private struct NonceResponse: Codable {
            let nonce: Int
        }
}

// MARK:- Common
extension AmberdataBlockchainRepository {
    
    private func dataTaskPublisher(for endpoint: String, postParameters: [String: Any]? = nil) -> URLSession.DataTaskPublisher {
        let host = "https://web3api.io/api/v2"
        let token = Keys.amberdataKey
        let url = URL(string: "\(host)/\(endpoint)")!
        var request = URLRequest(url: url)
        
        if let parameters = postParameters {
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        
        request.addValue(token, forHTTPHeaderField: "x-api-key")
        request.addValue("ethereum-mainnet", forHTTPHeaderField: "x-amberdata-blockchain-id")
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    private struct Response<T: Codable>: Codable {
        let payload: T
    }
    
    private struct Balance: Codable {
        let balance: String
    }
}

private struct AmberdataErrorResponse: Codable {
    struct Meta: Codable {
        let error: AmberdataError
    }
    struct AmberdataError: LocalizedError, Codable {
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
                let error = try JSONDecoder().decode(AmberdataErrorResponse.self, from: data).meta.error
                return error
            } catch {
                return error
            }
        }
    }
}

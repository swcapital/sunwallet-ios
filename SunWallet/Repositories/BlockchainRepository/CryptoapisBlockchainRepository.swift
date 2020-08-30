import Combine
import Foundation

struct CryptoapisBlockchainRepository: BlockchainRepository {
    
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
            return bitcoinBalance(for: wallet.address)
        case .eth:
            return etheriumBalance(for: wallet.address)
        default:
            fatalError("Not supported")
        }
    }
}

//MARK: - Bitcoin
extension CryptoapisBlockchainRepository {
    
    private func btcBalancePublisher(for address: String) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func btcTransactionsPublisher(for address: String) -> AnyPublisher<Response<[BitcoinTransaction]>, Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(address)/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[BitcoinTransaction]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func bitcoinBalance(for address: String) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = btcBalancePublisher(for: address)
        let transactionsPublisher = btcTransactionsPublisher(for: address)
        return Publishers.CombineLatest(balancePublisher, transactionsPublisher)
            .map { balanceResponse, transactionsResponse in
                let transactions = transactionsResponse.payload.map { Transaction(date: $0.datetime, value: $0.amount(for: address)) }
                let assetBalance = AssetBalance(asset: .btc, balance: balanceResponse.payload.balance.doubleValue, transactions: transactions)
                return .init(assets: [assetBalance])
            }
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
}

//MARK: - Etherium
extension CryptoapisBlockchainRepository {
    
    private func ethBalancePublisher(for address: String) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func ethTransactionsPublisher(for address: String) -> AnyPublisher<Response<[EtheriumTransaction]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(address)/basic/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[EtheriumTransaction]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func etheriumBalance(for address: String) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = ethBalancePublisher(for: address)
        let transactionsPublisher = ethTransactionsPublisher(for: address)
        let erc20Publisher = erc20WalletBalancePublisher(for: address)
        
        return Publishers.CombineLatest3(balancePublisher, transactionsPublisher, erc20Publisher)
            .map { balanceResponse, transactionsResponse, erc20 in
                let transactions = transactionsResponse.payload.map { Transaction(date: $0.datetime, value: $0.amount.doubleValue) }
                let assetBalance = AssetBalance(asset: .eth, balance: balanceResponse.payload.balance.doubleValue, transactions: transactions)
                return .init(assets: [assetBalance] + erc20.assets)
            }
            .eraseToAnyPublisher()
    }
    
    private struct EtheriumTransaction: Codable {
        let amount: String
        let datetime: Date
    }
}

//MARK: - ERC-20
extension CryptoapisBlockchainRepository {
    
    private func erc20BalancePublisher(for address: String) -> AnyPublisher<Response<[TokenBalance]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenBalance]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func erc20TransfersPublisher(for address: String) -> AnyPublisher<Response<[TokenTransfer]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(address)/transfers"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenTransfer]>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func erc20WalletBalancePublisher(for address: String) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = erc20BalancePublisher(for: address)
        let transfersPublisher = erc20TransfersPublisher(for: address)
        
        return Publishers.CombineLatest(balancePublisher, transfersPublisher)
            .map { balanceResponse, transfersResponse in
                
                let assets = balanceResponse.payload.map { balance -> AssetBalance in
                    let transactions = transfersResponse.payload
                        .filter { $0.symbol == balance.symbol }
                        .map { Transaction(date: $0.datetime, value: $0.value.doubleValue) }
                    return AssetBalance(asset: balance.symbol, balance: balance.balance.doubleValue, transactions: transactions)
                }
                return .init(assets: assets)
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
    
    private func dataTaskPublisher(for endpoint: String) -> URLSession.DataTaskPublisher {
        let host = "https://api.cryptoapis.io"
        let token = "22bfb126c375c756d0b85ae3d9ab6b398bd114b7"
        let url = URL(string: "\(host)/\(endpoint)")!
        var request = URLRequest(url: url)
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

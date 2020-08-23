import Combine
import Foundation

struct CryptoapisBlockchainRepository: BlockchainRepository {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.dateFormatter)
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
            .print()
            .eraseToAnyPublisher()
    }
    
    private func btcTransactionsPublisher(for address: String) -> AnyPublisher<Response<[_Transaction]>, Error> {
        let endpoint = "/v1/bc/btc/mainnet/address/\(address)/basic/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[_Transaction]>.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
    }
    
    private func bitcoinBalance(for address: String) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = btcBalancePublisher(for: address)
        let transactionsPublisher = btcTransactionsPublisher(for: address)
        return Publishers.CombineLatest(balancePublisher, transactionsPublisher)
            .map { balanceResponse, transactionsResponse in
                let transactions = transactionsResponse.payload.map { Transaction(date: $0.datetime, value: $0.amount.doubleValue) }
                let assetBalance = AssetBalance(asset: .btc, balance: balanceResponse.payload.balance.doubleValue, transactions: Array(transactions))
                return .init(assets: [assetBalance])
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - Etherium
extension CryptoapisBlockchainRepository {
    
    private func ethBalancePublisher(for address: String) -> AnyPublisher<Response<Balance>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<Balance>.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
    }
    
    private func ethTransactionsPublisher(for address: String) -> AnyPublisher<Response<[_Transaction]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/address/\(address)/basic/transactions"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[_Transaction]>.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
    }
    
    private func etheriumBalance(for address: String) -> AnyPublisher<WalletBalance, Error> {
        let balancePublisher = ethBalancePublisher(for: address)
        let transactionsPublisher = ethTransactionsPublisher(for: address)
        let erc20Publisher = erc20WalletBalancePublisher(for: address)
        
        return Publishers.CombineLatest3(balancePublisher, transactionsPublisher, erc20Publisher)
            .map { balanceResponse, transactionsResponse, erc20 in
                let transactions = transactionsResponse.payload.map { Transaction(date: $0.datetime, value: $0.amount.doubleValue) }
                let assetBalance = AssetBalance(asset: .eth, balance: balanceResponse.payload.balance.doubleValue, transactions: Array(transactions))
                return .init(assets: [assetBalance] + erc20.assets)
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - ERC-20
extension CryptoapisBlockchainRepository {
    
    private func erc20BalancePublisher(for address: String) -> AnyPublisher<Response<[TokenBalance]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(address)"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenBalance]>.self, decoder: decoder)
            .print()
            .eraseToAnyPublisher()
    }
    
    private func erc20TransfersPublisher(for address: String) -> AnyPublisher<Response<[TokenTransfer]>, Error> {
        let endpoint = "/v1/bc/eth/mainnet/tokens/address/\(address)/transfers"
        return dataTaskPublisher(for: endpoint)
            .extractData()
            .decode(type: Response<[TokenTransfer]>.self, decoder: decoder)
            .print()
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
                        .sorted(by: { $0.date < $1.date })
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

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return formatter
    }()
}


private extension String {
    var doubleValue: Double {
        Double(self) ?? 0
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

    private struct _Transaction: Codable {
        let amount: String
        let datetime: Date
    }
}

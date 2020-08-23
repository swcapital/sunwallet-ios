import Combine
import Foundation

private let host = "https://api.blockchair.com"
private let token = "PA__A7AmX35RoCXNBMUTKsR2xVR5u7IB"

struct BlockchairBlockchainRepository: BlockchainRepository {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.bcDateFormatter)
        return decoder
    }
    
    func balance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        switch wallet.asset {
        case .btc:
            return bitcoinBalance(address: wallet.address)
        case .eth:
            return etheriumBalance(address: wallet.address)
        default:
            fatalError("Not supported")
        }
    }
}

//MARK: - Bitcoin
private let satoshiRatio: Double = 100_000_000

extension BlockchairBlockchainRepository {
    
    private func bitcoinBalance(address: String) -> AnyPublisher<WalletBalance, Error> {
        let address = "\(host)/bitcoin/dashboards/address/\(address)" + "?limit=1&transaction_details=true"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalancesResponse<BitcoinData>.self, decoder: decoder)
            .print()
            .map {
                let data = $0.data.first!.value
                let balance = (data.address.balance ?? 0) / satoshiRatio
                let transactions = data.transactions
                    .map { Transaction(date: $0.time, value: $0.balanceChange / satoshiRatio) }
                    .reversed()
                let assetBalance = AssetBalance(asset: .btc, balance: balance, transactions: Array(transactions))
                return .init(assets: [assetBalance])
        }
        .eraseToAnyPublisher()
    }
    
    private struct BitcoinData: Codable {
        let address: BitcoinBalance
        let transactions: [BitcoinTransaction]
    }
    
    private struct BitcoinBalance: Codable {
        let balance: Double?
        let balanceUSD: Double
        
        enum CodingKeys: String, CodingKey {
            case balance = "balance"
            case balanceUSD = "balance_usd"
        }
    }
    
    private struct BitcoinTransaction: Codable {
        let time: Date
        let balanceChange: Double
        
        enum CodingKeys: String, CodingKey {
            case time = "time"
            case balanceChange = "balance_change"
        }
    }
}

//MARK: - Etherium
private let weiRatio: Double = 1_000_000_000_000_000_000

extension BlockchairBlockchainRepository {
    
    private func etheriumBalance(address: String) -> AnyPublisher<WalletBalance, Error> {
        let address = "\(host)/ethereum/dashboards/address/\(address)" + "?erc_20=true"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalancesResponse<EtheriumData>.self, decoder: decoder)
            .print()
            .map {
                let data = $0.data.first!.value
                let balance = (data.address.balance?.doubleValue ?? 0) / weiRatio
                let transactions = data.calls
                    .map { Transaction(date: $0.time, value: $0.value / weiRatio) }
                    .reversed()
                let assetBalance = AssetBalance(asset: .eth, balance: balance, transactions: Array(transactions))
                
                let erc20 = data.layer2?.erc20Array.map { erc20 -> AssetBalance in
                    let asset = Asset(erc20.symbol)
                    let balance = erc20.balance.doubleValue / weiRatio
                    return AssetBalance(asset: asset, balance: balance, transactions: [])
                }
                return .init(assets: [assetBalance] + (erc20 ?? []))
        }
        .eraseToAnyPublisher()
    }
    
    private struct EtheriumData: Codable {
        let address: EtheriumBalance
        let calls: [EtheriumCall]
        let layer2: Layer2?
        
        enum CodingKeys: String, CodingKey {
            case address = "address"
            case calls = "calls"
            case layer2 = "layer_2"
        }
    }
    
    private struct EtheriumBalance: Codable {
        let balance: String?
        let balanceUSD: Double
        
        enum CodingKeys: String, CodingKey {
            case balance = "balance"
            case balanceUSD = "balance_usd"
        }
    }
    
    private struct EtheriumCall: Codable {
        let time: Date
        let value: Double
        
        enum CodingKeys: String, CodingKey {
            case time = "time"
            case value = "value"
        }
    }
    
    private struct Layer2: Codable {
        let erc20Array: [ERC20]
        
        enum CodingKeys: String, CodingKey {
            case erc20Array = "erc_20"
        }
    }
    
    private struct ERC20: Codable {
        let balance: String
        let symbol: String
        
        enum CodingKeys: String, CodingKey {
            case balance = "balance"
            case symbol = "token_symbol"
        }
    }
}

private struct BalancesResponse<T: Codable>: Codable {
    let data: [String: T]
}

private extension DateFormatter {
    static let bcDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

private extension String {
    var doubleValue: Double {
        Double(self) ?? 0
    }
}

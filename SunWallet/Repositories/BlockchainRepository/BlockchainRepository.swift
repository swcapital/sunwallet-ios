import Combine
import Foundation

private let host = "https://api.blockcypher.com"

struct BlockchainRepository {
    
    func balance(for wallet: Wallet) -> AnyPublisher<Double, Error> {
        let address = "\(host)/v1/\(wallet.asset.code)/main/addrs/\(wallet.address)/balance"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalanceResponse.self, decoder: JSONDecoder())
            .print()
            .map(\.balance)
            .eraseToAnyPublisher()
    }
}

private struct BalanceResponse: Codable {
    let balance: Double
}

private extension WalletCurrency {
    var code: String {
        switch self {
        case .btc: return "btc"
        case .eth: return "eth"
        }
    }
}

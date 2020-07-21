import Combine
import Foundation

private let host = "https://api.blockcypher.com"
private let token = "ee2754cbdba243f98e55a14b8b043b1e"

struct BlockchyperBlockchainRepository: BlockchainRepository {
    
    func balance(for wallet: Wallet) -> AnyPublisher<Double, Error> {
        let address = "\(host)/v1/\(wallet.asset.code)/main/addrs/\(wallet.address)/balance" + "?token=\(token)"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalanceResponse.self, decoder: JSONDecoder())
            .map(\.balance)
            .eraseToAnyPublisher()
    }
}

private struct BalanceResponse: Codable {
    let balance: Double
}

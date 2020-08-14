import Combine
import Foundation

private let host = "https://api.blockcypher.com"
private let token = "ee2754cbdba243f98e55a14b8b043b1e"

struct BlockchyperBlockchainRepository: BlockchainRepository {
    
    func balance(for wallet: Wallet) -> AnyPublisher<WalletBalance, Error> {
        let address = "\(host)/v1/\(wallet.asset.code)/main/addrs/\(wallet.address)/balance" + "?token=\(token)"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalanceResponse.self, decoder: JSONDecoder())
            .map {
                let assetBalance = AssetBalance(asset: wallet.asset, balance: $0.balance, transactions: [])
                return WalletBalance(assets: [assetBalance])
            }
            .eraseToAnyPublisher()
    }
}

private struct BalanceResponse: Codable {
    let balance: Double
}

import Combine
import Foundation

private let host = "https://api.blockchair.com"
private let token = "PA__A7AmX35RoCXNBMUTKsR2xVR5u7IB"

struct BlockchairBlockchainRepository: BlockchainRepository {
    
    func balance(for wallet: Wallet) -> AnyPublisher<Double, Error> {
        let address = "\(host)/\(wallet.asset.endpoint)/dashboards/address/\(wallet.address)" + "?limit=1"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: BalancesResponse.self, decoder: JSONDecoder())
            .map { $0.data.first!.value.address.balanceUSD }
            .eraseToAnyPublisher()
    }
}

private struct BalancesResponse: Codable {
    let data: [String: BalanceResponse]
}

private struct BalanceResponse: Codable {
    let address: AddressResponse
}

private struct AddressResponse: Codable {
    let balance: Double?
    let balanceUSD: Double
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case balanceUSD = "balance_usd"
    }
}

private extension Asset {
    var endpoint: String {
        switch self {
        case .btc: return "bitcoin"
        case .eth: return "ethereum"
        default: fatalError()
        }
    }
}

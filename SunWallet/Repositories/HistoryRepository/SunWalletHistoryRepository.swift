import Foundation
import Combine

private let host = "http://35.224.27.160:8080"
//private let host = "http://127.0.0.1:8080"

struct SunWalletHistoryRepository: HistoryRepository {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    func history(base: Asset, targets: [Asset]) -> AnyPublisher<[ExchangeHistory], Error> {
        let targetsString = targets.map { $0.code }.joined(separator: ",")
        let address = "\(host)/history/q/\(base.code)/\(targetsString)"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .extractData()
            .decode(type: HistoryResponse.self, decoder: decoder)
            .map(\.pairs)
            .eraseToAnyPublisher()
    }
}

private extension SunWalletHistoryRepository {
    struct HistoryResponse: Codable {
        let pairs: [ExchangeHistory]
    }
}

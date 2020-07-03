import Foundation
import Combine

private let host = "http://35.224.27.160:8080"
//private let host = "http://127.0.0.1:8080"

enum HTTPError: LocalizedError {
    case networkError
    
    var errorDescription: String? { "Network error" }
}

struct SunWalletHistoryRepository: HistoryRepository {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    func bootstrapHistory(base: Asset) -> AnyPublisher<[TradePairHistory], Error> {
        let address = "\(host)/history/bootstrap/\(base.code)"
        let url = URL(string: address)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.networkError
                }
                return output.data
            }
            .decode(type: HistoryResponse.self, decoder: decoder)
            .map(\.pairs)
            .eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == Data  {
    
    func printJsonData() -> AnyPublisher<Self.Output, Self.Failure> {
        map { data in
            Swift.print(String(data: data, encoding: .utf8) ?? "Error")
            return data
        }
        .eraseToAnyPublisher()
    }
}

private extension SunWalletHistoryRepository {
    struct HistoryResponse: Codable {
        let pairs: [TradePairHistory]
    }
}

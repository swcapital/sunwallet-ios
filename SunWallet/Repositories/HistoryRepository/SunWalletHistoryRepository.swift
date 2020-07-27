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
            .map { response in
                response.pairs.map {
                    ExchangeHistory(source: $0.source, destination: $0.destination, historySet: $0.historySet.historySet)
                }
            }
            .eraseToAnyPublisher()
    }
}

let oneYearInterval: TimeInterval = 60 * 60 * 24 * 365

private extension SunWalletHistoryRepository {
    struct HistoryResponse: Codable {
        let pairs: [Pair]
    }
    
    struct Pair: Codable {
        let source: Asset
        let destination: Asset
        let historySet: _HistorySet
    }
    
    struct _HistorySet: Codable {
        let hourly: [TradeData]
        let daily: [TradeData]
        let weekly: [TradeData]
        let monthly: [TradeData]
        let all: [TradeData]
        
        private var yearly: [TradeData] {
            let yearAgoDate = Date(timeIntervalSinceNow: -oneYearInterval)
            return all.filter { $0.date > yearAgoDate }
        }
        
        fileprivate var historySet: HistorySet {
            .init(
                hourly: hourly.historyValues(),
                daily: daily.historyValues(),
                weekly: weekly.historyValues(),
                monthly: monthly.historyValues(),
                yearly: yearly.historyValues(),
                all: all.historyValues()
            )
        }
    }

    struct TradeData: Codable {
        let date: Date
        let close: Double
    }
}

private extension Array where Element == SunWalletHistoryRepository.TradeData {
    
    func historyValues() -> [HistoryValue] {
        map { HistoryValue(date: $0.date, value: $0.close) }
    }
}

import Foundation
import Combine

protocol HistoryRepository {
    func bootstrapHistory(base: Asset) -> AnyPublisher<[ExchangeHistory], Error>
}

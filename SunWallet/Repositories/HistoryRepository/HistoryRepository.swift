import Combine
import Foundation

protocol HistoryRepository {
    func history(base: Asset, targets: [Asset]) -> AnyPublisher<[ExchangeHistory], Error>
}

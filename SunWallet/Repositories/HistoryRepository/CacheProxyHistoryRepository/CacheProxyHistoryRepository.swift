import Foundation
import Combine

struct CacheProxyHistoryRepository: HistoryRepository {
    let cacheRepository = CacheHistoryRepository()
    let historyRepository: HistoryRepository = SunWalletHistoryRepository()
    
    func bootstrapHistory(base: Asset) -> AnyPublisher<[TradePairHistory], Error> {
        if let history = cacheRepository.bootstrapHistory() {
            let subject = CurrentValueSubject<[TradePairHistory], Error>(history)
            return subject.eraseToAnyPublisher()
        } else {
            return historyRepository.bootstrapHistory(base: base)
                .map { history -> [TradePairHistory] in
                    self.cacheRepository.saveBootstrapHistory(history)
                    return history
                }
                .replaceError(with: bundleData())
                .setFailureType(to: Swift.Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func bundleData() -> [TradePairHistory] {
        let url = Bundle.main.url(forResource: "bootstrap", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([TradePairHistory].self, from: data)
    }
}

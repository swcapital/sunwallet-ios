import Foundation
import Combine

struct CacheProxyHistoryRepository {
    let cacheRepository = CacheHistoryRepository()
    let historyRepository: HistoryRepository = SunWalletHistoryRepository()
    
    func bootstrapHistory(base: Asset) -> AnyPublisher<[TradePairHistory], Never> {
        return historyRepository.bootstrapHistory(base: base)
            .map { history -> [TradePairHistory] in
                self.cacheRepository.saveBootstrapHistory(history)
                return history
            }
            .replaceError(with: cachedData())
            .eraseToAnyPublisher()
    }
    
    private func cachedData() -> [TradePairHistory] {
        cacheRepository.bootstrapHistory() ?? bundleData()
    }
    
    private func bundleData() -> [TradePairHistory] {
        let url = Bundle.main.url(forResource: "bootstrap", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([TradePairHistory].self, from: data)
    }
}

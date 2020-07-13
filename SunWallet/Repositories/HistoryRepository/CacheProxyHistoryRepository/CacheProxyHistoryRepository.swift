import Foundation
import Combine

struct CacheProxyHistoryRepository {
    private let cacheRepository = CacheRepository()
    
    let historyRepository = SunWalletHistoryRepository()
    
    func history(base: Asset, targets: [Asset]) -> AnyPublisher<[ExchangeHistory], Never> {
        
        historyRepository.history(base: base, targets: targets)
            .map { history -> [ExchangeHistory] in
                self.addCache(history)
                return history
            }
            .replaceError(with: cachedData(base: base, targets: targets))
            .eraseToAnyPublisher()
    }
    
    func cachedData(base: Asset, targets: [Asset]) -> [ExchangeHistory] {
        guard let cache = historyCache() else {
            return bundleData()
        }
        return cache.get(base: base, targets: targets).compactMap { $0 }
    }
    
    private func bundleData() -> [ExchangeHistory] {
        let url = Bundle.main.url(forResource: "bootstrap", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return (try? JSONDecoder().decode([ExchangeHistory].self, from: data)) ?? []
    }
    
    private func addCache(_ history: [ExchangeHistory]) {
        var cache = historyCache() ?? .init()
        cache.add(history)
        cacheRepository.save(cache, atKey: .history)
    }
    
    private func historyCache() -> HistoryCache? {
        cacheRepository.load(atKey: .history)
    }
}

private extension CacheKey {
    static let history = CacheKey(value: "history")
}

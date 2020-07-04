import Foundation
import Combine

private let bootstrapHistoryKey = "bootstrap"

struct CacheHistoryRepository {
    private let cacheRepository: CacheRepository = RealCacheRepository()
    
    func bootstrapHistory() -> [TradePairHistory]? {
        cacheRepository.load(atKey: bootstrapHistoryKey)
    }
    
    func saveBootstrapHistory(_ history: [TradePairHistory]) {
        cacheRepository.save(history, atKey: bootstrapHistoryKey)
    }
}

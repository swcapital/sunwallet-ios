import Foundation
import Combine

//struct CacheHistoryRepository: HistoryRepository {
//    static private var history: [String: [String: Cache<[TradeData]>]] = [:]
//    
//    func bootstrapHistory(base: Asset) -> AnyPublisher<[TradePairHistory], Error> {
//        
//    }
//    func bootstrapHistory(base: Asset) -> AnyPublisher<[TradePairHistory], Error> {
//        let cache = Self.history[context.from.lowercased()]?[context.to.lowercased()]
//        let value = cache?.get(atKey: context.period.rawValue)
//        return request.eventLoop.future(value)
//    }
//    
//    func save(_ value: [TradeData], context: HistoryContext) {
//        let source = context.from.lowercased()
//        let destination = context.to.lowercased()
//        
//        var sourcePairs = Self.history[source] ?? [:]
//        var cache = sourcePairs[destination] ?? .init()
//        
//        let date = validDate(for: context.period)
//        cache.set(value, atKey: context.period.rawValue, validUntil: date)
//        
//        sourcePairs[destination] = cache
//        Self.history[source] = sourcePairs
//    }
//    
//    private func validDate(for period: TimePeriod) -> Date {
//        let hour: Double = 60 * 60
//        let minute: Double = 60
//        
//        switch period {
//        case .all: return Date(timeIntervalSinceNow: 12 * hour)
//        case .monthly: return Date(timeIntervalSinceNow: 4 * hour)
//        case .weekly: return Date(timeIntervalSinceNow: 1 * hour)
//        case .daily: return Date(timeIntervalSinceNow: 10 * minute)
//        case .hourly: return Date(timeIntervalSinceNow: 1 * minute)
//        }
//    }
//}

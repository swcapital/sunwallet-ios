import Foundation

extension CacheProxyHistoryRepository {
    internal struct HistoryCache: Codable {
        private var storage: [ExchangeHistory] = []
        
        mutating func add(_ history: [ExchangeHistory]) {
            storage.append(contentsOf: history)
        }
        
        func get(base: Asset, targets: [Asset]) -> [ExchangeHistory?] {
            targets.map { target in
                storage.first(where: {
                    $0.source == target && $0.destination == base
                })
            }
        }
    }
}

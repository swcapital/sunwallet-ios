import Foundation

extension HistoryStore {
    internal struct HistoryCache: Codable {
        private var storage: [_ExchangeHistory] = []
        
        mutating func add(_ history: [ExchangeHistory]) {
            storage.append(contentsOf: history.map { .init($0) })
        }
        
        func get(base: Asset, targets: [Asset]) -> [ExchangeHistory?] {
            targets.map { target in
                storage.first(where: { $0.source == target && $0.destination == base })
                    .map { $0.original }
            }
        }
        
        func get(base: Asset, targets: [Asset], maxAge: TimeInterval) -> [ExchangeHistory?] {
            let threshold = Date(timeIntervalSinceNow: -maxAge)
            return targets.map { target in
                storage.first(where: { $0.source == target && $0.destination == base && $0.date > threshold })
                    .map { $0.original }
            }
        }
    }
}

private struct _ExchangeHistory: Codable {
    let source: Asset
    let destination: Asset
    let historySet: _TradeHistorySet
    let date = Date()
    
    init(_ original: ExchangeHistory) {
        self.source = original.source
        self.destination = original.destination
        self.historySet = .init(original.historySet)
    }
    
    var original: ExchangeHistory {
        .init(source: source, destination: destination, historySet: historySet.original)
    }
}

private struct _TradeHistorySet: Codable {
    let values: [HistoryValue]
    
    let hourly: Range<Int>
    let daily: Range<Int>
    let weekly: Range<Int>
    let monthly: Range<Int>
    let yearly: Range<Int>
    let all: Range<Int>
    
    init(_ original: HistorySet) {
        var values: [HistoryValue] = []
        
        var i = 0
        let ranges = [
            original.hourly,
            original.daily,
            original.weekly,
            original.monthly,
            original.yearly,
            original.all
        ].map { historyRange -> Range<Int> in
            i = values.count
            values += historyRange
            return i..<values.count
        }
        
        self.values = values
        
        self.hourly = ranges[0]
        self.daily = ranges[1]
        self.weekly = ranges[2]
        self.monthly = ranges[3]
        self.yearly = ranges[4]
        self.all = ranges[5]
    }
    
    var original: HistorySet {
        .init(
            hourly: historyRange(hourly),
            daily: historyRange(daily),
            weekly: historyRange(weekly),
            monthly: historyRange(monthly),
            yearly: historyRange(yearly),
            all: historyRange(all)
        )
    }
    
    private func historyRange(_ range: Range<Int>) -> [HistoryValue] {
        Array(values[range])
    }
}

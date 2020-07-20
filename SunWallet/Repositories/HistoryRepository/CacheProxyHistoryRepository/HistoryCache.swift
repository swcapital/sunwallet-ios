import Foundation

extension CacheProxyHistoryRepository {
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
    }
}

private struct _ExchangeHistory: Codable {
    let source: Asset
    let destination: Asset
    let historySet: _TradeHistorySet
    
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
    let dates: [Date]
    let values: [Double]
    
    let hourly: Range<Int>
    let daily: Range<Int>
    let weekly: Range<Int>
    let monthly: Range<Int>
    let all: Range<Int>
    
    init(_ original: TradeHistorySet) {
        var dates: [Date] = []
        var values: [Double] = []
        
        var i = 0
        let ranges = [original.hourly, original.daily, original.weekly, original.monthly, original.yearly].map { tradeDataSet -> Range<Int> in
            i = dates.count
            dates += tradeDataSet.map { $0.date }
            values += tradeDataSet.map { $0.close }
            return i..<dates.count
        }
        
        self.dates = dates
        self.values = values
        
        self.hourly = ranges[0]
        self.daily = ranges[1]
        self.weekly = ranges[2]
        self.monthly = ranges[3]
        self.all = ranges[4]
    }
    
    var original: TradeHistorySet {
        .init(
            hourly: tradeDataSet(hourly),
            daily: tradeDataSet(daily),
            weekly: tradeDataSet(weekly),
            monthly: tradeDataSet(monthly),
            all: tradeDataSet(all)
        )
    }
    
    private func tradeDataSet(_ range: Range<Int>) -> [TradeData] {
        zip(dates[range], values[range]).map { TradeData(date: $0.0, close: $0.1) }
    }
}

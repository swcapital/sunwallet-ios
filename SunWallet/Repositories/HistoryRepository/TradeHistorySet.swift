import Foundation

let oneYearInterval: TimeInterval = 60 * 60 * 24 * 365

struct TradeHistorySet: Codable {
    let hourly: [TradeData]
    let daily: [TradeData]
    let weekly: [TradeData]
    let monthly: [TradeData]
    let all: [TradeData]
    
    var yearly: [TradeData] {
        let yearAgoDate = Date(timeIntervalSinceNow: -oneYearInterval)
        return all.filter { $0.date > yearAgoDate }
    }
    
    var currentPrice: Double { hourly.last?.close ?? 0 }
    var currentPriceChange: Double { ( (daily.last?.close ?? 0) / (daily.dropLast().last?.close ?? 0)) - 1 }
}

extension Array where Element == TradeData {
    
    func rawValues() -> [Double] {
        map { $0.close }
    }
}

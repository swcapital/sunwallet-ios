import Foundation

struct TradePairHistory: Codable {
    let source: String
    let destination: String
    let historySet: TradeHistorySet
}

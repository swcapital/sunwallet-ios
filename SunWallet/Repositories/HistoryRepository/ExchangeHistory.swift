import Foundation

struct ExchangeHistory: Codable {
    let source: Asset
    let destination: Asset
    let historySet: TradeHistorySet
}

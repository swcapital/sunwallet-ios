import Foundation

struct AssetHistory {
    let asset: Asset
    let balance: Double
    /// User currency balances
    let equity: Double
    let historySet: HistorySet?
}

import Foundation

struct AssetHistory: Identifiable {
    let id = UUID()
    
    let asset: Asset
    let balance: Double
    /// User currency balances
    let equity: Double
    let transactions: [AssetTransaction]
    let historySet: HistorySet?
}

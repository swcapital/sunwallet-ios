import Foundation

struct AssetTransaction: Identifiable {
    let id = UUID()
    
    let asset: Asset
    let value: Double
    let currencyValue: Double
    let date: Date
}

extension AssetTransaction: Comparable {
    
    static func < (lhs: AssetTransaction, rhs: AssetTransaction) -> Bool {
        lhs.date > rhs.date
    }
}

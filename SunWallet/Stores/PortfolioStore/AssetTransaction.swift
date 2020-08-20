import Foundation

struct AssetTransaction: Identifiable {
    let id = UUID()
    
    let asset: Asset
    let value: Double
    let currencyValue: Double
    let date: Date
}

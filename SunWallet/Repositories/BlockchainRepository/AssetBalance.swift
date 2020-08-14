import Foundation

struct AssetBalance: Codable {
    let asset: Asset
    let balance: Double
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let date: Date
    let value: Double
}

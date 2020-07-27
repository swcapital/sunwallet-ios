import Foundation

struct WalletInfo {
    let balance: Double
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let date: Date
    let value: Double
}

import Foundation

struct WalletBalance: Codable {
    let wallet: Wallet
    let assets: [AssetBalance]
}

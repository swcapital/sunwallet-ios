import Foundation

struct Account: Identifiable {
    let id = UUID()
    
    let wallet: Wallet
    let asset: Asset
}

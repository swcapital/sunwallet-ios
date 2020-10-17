import Foundation

struct Account: Identifiable {
    let id = UUID()
    
    let wallet: Wallet
    let asset: Asset
    let amount: Double
    let equity: Double
    let price: Double
}

extension Account: Equatable {
    
    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.wallet.address == rhs.wallet.address && lhs.asset == rhs.asset && lhs.amount == rhs.amount
    }
}

import Foundation

class User: ObservableObject {
    let favorites: [Asset]
    let balance: [Asset: Double]
    var totalDollarBalance: Double { balance.reduce(0) { $0 + dollarBalance($1.key) } }
    let balanceHistory: ValueHistory = .init()
    
    init(favorites: [Asset], balance: [Asset: Double]) {
        self.favorites = favorites
        self.balance = balance
    }
    
    func assetBalance(_ asset: Asset) -> Double {
        balance[asset] ?? 0
    }
    
    func dollarBalance(_ asset: Asset) -> Double {
        assetBalance(asset) * asset.dollarPrice
    }
    
    func walletAddress(_ asset: Asset) -> String {
        "jnjdskfsfsdfGVGd88"
    }
}

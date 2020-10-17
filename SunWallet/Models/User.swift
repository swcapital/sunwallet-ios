import Foundation

class User: ObservableObject {
    let favorites: [Asset2]
    let balance: [Asset2: Double]
    var totalDollarBalance: Double { balance.reduce(0) { $0 + dollarBalance($1.key) } }
    let balanceHistory: ValueHistory = .init()
    
    init(favorites: [Asset2], balance: [Asset2: Double]) {
        self.favorites = favorites
        self.balance = balance
    }
    
    func assetBalance(_ asset: Asset2) -> Double {
        balance[asset] ?? 0
    }
    
    func dollarBalance(_ asset: Asset2) -> Double {
        assetBalance(asset) * asset.dollarPrice
    }
    
    func walletAddress(_ asset: Asset2) -> String {
        "jnjdskfsfsdfGVGd88"
    }
}

import Foundation

struct Wallet: Codable  {
    var address: String
    var balances: [Asset: Double]
    var balanceHistories: [Asset: ValueHistory]
    var valueHistory: ValueHistory = .init()
    var dollarBalance: Double // { balances.reduce(0) { $0 + dollarBalance($1.key) } }
    var watchList: [Asset]
        
    init(address: String, balances: [Asset: Double], balanceHistories: [Asset: ValueHistory],
         valueHistory: ValueHistory, dollarBalance: Double, watchList: [Asset]) {
        self.address = address
        self.balances = balances
        self.balanceHistories = balanceHistories
        self.valueHistory = valueHistory
        self.dollarBalance = dollarBalance
        self.watchList = watchList
    }
    
    func assetBalance(_ asset: Asset) -> Double {
        balance[asset] ?? 0
    }
    
    func dollarBalance(_ asset: Asset) -> Double {
        assetBalance(asset) * asset.price
    }
}

extension Wallet: Identifiable {
    var id: String { address }
}

extension Wallet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

extension Wallet: Comparable {
    static func < (lhs: Wallet, rhs: Wallet) -> Bool {
        lhs.asset < rhs.asset
    }
}

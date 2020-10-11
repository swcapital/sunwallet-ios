import Foundation

struct WalletHistory {
    let id = UUID()
    
    let wallet: Wallet
    let assetsHistory: [AssetHistory]
    
    var transactions: [AssetTransaction] {
        assetsHistory.map(\.transactions).reduce([], +).sorted(by: { $0.date < $1.date })
    }
    var totalEquity: Double {
        assetsHistory.map(\.equity).reduce(0, +)
    }
    var historySet: HistorySet? {
        assetsHistory.compactMap(\.historySet).total()
    }
}

extension WalletHistory: Equatable {
    
    static func == (lhs: WalletHistory, rhs: WalletHistory) -> Bool {
        lhs.id == rhs.id
    }
}

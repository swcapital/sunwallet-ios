import Foundation

struct WalletHistory {
    // Using for fast comparsation
    private let id = UUID()
    
    let assetsHistory: [AssetHistory]
    
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

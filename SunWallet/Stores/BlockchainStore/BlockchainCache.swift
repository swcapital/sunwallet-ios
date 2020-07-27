import Foundation

extension BlockchainStore {
    internal struct BlockchainCache: Codable {
        private var storage: [Wallet: _WalletInfo] = [:]
        
        mutating func add(_ walletInfo: WalletInfo, for wallet: Wallet) {
            storage[wallet] = _WalletInfo(walletInfo)
        }
        
        func get(for wallet: Wallet) -> WalletInfo? {
            storage[wallet]?.original()
        }
        
        func get(for wallet: Wallet, maxAge: TimeInterval) -> WalletInfo? {
            let threshold = Date(timeIntervalSinceNow: -maxAge)
            guard let info = storage[wallet], info.date > threshold else { return nil }
            return info.original()
        }
    }
}

fileprivate struct _WalletInfo: Codable {
    let balance: Double
    let transactions: [Transaction]
    let date: Date
    
    init(_ walletInfo: WalletInfo) {
        self.balance = walletInfo.balance
        self.transactions = walletInfo.transactions
        self.date = Date()
    }
    
    func original() -> WalletInfo {
        .init(balance: balance, transactions: transactions)
    }
}

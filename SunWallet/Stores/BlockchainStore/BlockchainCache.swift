import Foundation

extension BlockchainStore {
    internal struct BlockchainCache: Codable {
        private var storage: [Wallet: Wrapper] = [:]
        
        mutating func add(_ walletBalance: WalletBalance, for wallet: Wallet) {
            storage[wallet] = Wrapper(walletBalance)
        }
        
        func get(for wallet: Wallet) -> WalletBalance? {
            storage[wallet]?.original()
        }
        
        func get(for wallet: Wallet, maxAge: TimeInterval) -> WalletBalance? {
            let threshold = Date(timeIntervalSinceNow: -maxAge)
            guard let info = storage[wallet], info.date > threshold else { return nil }
            return info.original()
        }
    }
}

fileprivate struct Wrapper: Codable {
    let walletBalance: WalletBalance
    let date: Date
    
    init(_ walletBalance: WalletBalance) {
        self.walletBalance = walletBalance
        self.date = Date()
    }
    
    func original() -> WalletBalance {
        walletBalance
    }
}

import Combine
import Foundation
import SwiftUI

class BlockchainStore: ObservableObject {
    private var cancalables: Set<AnyCancellable> = []
    
    let walletStore: WalletStore
    
    @Published
    var balances: [Wallet: Double] = [:]
    
    var totalBalance: Double { balances.values.reduce(0, +) }
    
    init(walletStore: WalletStore) {
        self.walletStore = walletStore
        
        walletStore.objectWillChange
            .sink(receiveValue: { self.updateBalances() })
            .store(in: &cancalables)
        
        updateBalances()
    }
    
    func updateBalances() {
        let blockchainRepository = BlockchainRepository()
        let wallets = walletStore.wallets
        
        let pubs = wallets.map {
            blockchainRepository.balance(for: $0)
        }
        
        Publishers.MergeMany(pubs)
            .collect()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    self.balances = Dictionary(uniqueKeysWithValues: zip(wallets, $0))
                }
            )
            .store(in: &cancalables)
    }
}

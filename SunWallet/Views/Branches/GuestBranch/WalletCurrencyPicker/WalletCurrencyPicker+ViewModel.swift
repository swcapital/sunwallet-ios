import Combine
import Foundation

extension WalletCurrencyPicker {
    class ViewModel: ObservableObject {
        private var cancellable: AnyCancellable?
                
        let masterKeys: [MasterKey]
        let showBalances: Bool
        
        @Published
        var wallets: [Wallet] = []
        
        @Published
        var isLoading: Bool = false
        
        @Published
        var error: String?
        
        @Published
        var balances: [Wallet: Double] = [:]
        
        @Published
        var selection: Set<Wallet> = []
        
        var canContinue: Bool { !selection.isEmpty }
        
        init(masterKeys: [MasterKey], showBalances: Bool) {
            self.masterKeys = masterKeys
            self.showBalances = showBalances
            
            self.updateWallets()
        }
        
        func updateWallets() {
            isLoading = true
            DispatchQueue.global(qos: .background).async {
                let wallets = self.masterKeys.map { $0.wallets() }.reduce([], +)
                DispatchQueue.main.async {
                    self.wallets = wallets
                    self.selection = Set(wallets)
                    self.isLoading = false
                    
                    self.updateBalances()
                }
            }
        }
                
        private func updateBalances() {
            guard showBalances else { return }
            
            isLoading = true
            let blockchainRepository = BlockchainRepository()
            
            let pubs = wallets.map {
                blockchainRepository.balance(for: $0)
            }
            
            cancellable = Publishers.MergeMany(pubs)
                .collect()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in self.isLoading = false },
                    receiveValue: { self.balances = Dictionary(uniqueKeysWithValues: zip(self.wallets, $0.map { $0 + 1 })) }
                )            
        }
        
        func balance(for wallet: Wallet) -> Double? {
            guard showBalances else { return nil }
            return balances[wallet, default: 0]
        }
        
        func saveData() {
            let masterKeys = self.masterKeys.filter { masterKey in
                wallets.first(where: { $0.masterKeyID == masterKey.id }) != nil
            }
            let walletStore = WalletStore()
            guard walletStore.save(masterKeys: masterKeys) else {
                self.error = "Couldn't save wallets"
                return
            }
            walletStore.save(wallets: wallets)
        }
    }
}

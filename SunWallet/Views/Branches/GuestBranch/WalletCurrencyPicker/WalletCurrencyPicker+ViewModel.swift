import Combine
import Foundation

extension WalletCurrencyPicker {
    class ViewModel: ObservableObject {
        @Published
        private var state: State = .none
        
        let objectWillChange = PassthroughSubject<Void, Never>()
        
        let wallets: [Wallet]
        let masterKeys: [MasterKey]
        let showBalances: Bool
        
        var isLoading: Bool { state.isLoading }
        
        @Published
        var error: String?
        
        init(masterKeys: [MasterKey], showBalances: Bool) {
            self.masterKeys = masterKeys
            self.showBalances = showBalances
            
            let wallets = masterKeys.map { $0.wallets() }.reduce([], +)
            self.wallets = wallets
        }
                
        func onAppear() {
            guard showBalances else { return }
            guard case State.none = state else { return }
                        
            let blockchainRepository = BlockchainRepository()
            
            let pubs = wallets.map {
                blockchainRepository.balance(for: $0)
            }
            
            let cancellable = Publishers.MergeMany(pubs)
                .collect()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: {
                        let value = Dictionary(uniqueKeysWithValues: zip(self.wallets, $0))
                        self.state = .loaded(value)
                    }
                )
            
            state = .loading(cancellable)
        }
        
        func balance(for wallet: Wallet) -> Double? {
            guard showBalances else { return nil }
            guard case State.loaded(let balances) = state else { return 0 }
            return balances[wallet, default: 0]
        }
        
        func save(wallets: [Wallet]) {
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

extension WalletCurrencyPicker.ViewModel {
    enum State {
        case none
        case loading(AnyCancellable)
        case loaded([Wallet : Double])
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
}

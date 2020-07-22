import SwiftUI

struct WalletCurrencyPicker: View {
    let masterKeys: [MasterKey]
    let showBalances: Bool
    
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @EnvironmentObject
    var blockchainStore: BlockchainStore
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var wallets: [Wallet] = []
    
    @State
    private var isLoading: Bool = false
    
    @State
    private var error: String?
    
    @State
    private var balances: [Wallet: Double]?
    
    @State
    private var selection: Set<Wallet> = []
    
    private var canContinue: Bool { !selection.isEmpty }
    
    private var continueButton: some View {
        Button("Continue") {
            self.saveData()
            self.appStateStore.logIn()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!canContinue)
    }
    
    private var walletList: some View {
        ScrollView {
            Divider()
            ForEach(wallets) { wallet in
                Cell(
                    wallet: wallet,
                    balance: self.balance(for: wallet),
                    selection: self.$selection
                )
                .padding(.horizontal)
                
                Divider()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            walletList
            
            Spacer()
            
            continueButton
                .padding(.horizontal)
        }
        .padding(.bottom, 48)
        .showAlert(error: $error)
        .showLoading(isLoading)
        .onAppear(perform: updateWalletsIfNeeded)
        .navigationBarTitle("Choose wallets", displayMode: .inline)
    }
    
    private func updateWalletsIfNeeded() {
        guard wallets.count == 0 else { return }
        
        isLoading = true
        DispatchQueue.global(qos: .background).async {
            let wallets = self.masterKeys.map { $0.wallets() }.reduce([], +).sorted(by: { $0.asset < $1.asset})
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
        blockchainStore.balances(wallets: wallets) {
            self.balances = $0
            self.isLoading = false
        }
    }
    
    private func balance(for wallet: Wallet) -> Double? {
        guard showBalances else { return nil }
        return balances?[wallet, default: 0] ?? 0
    }
    
    private func saveData() {
        let wallets = Array(selection)
        
        let masterKeys = self.masterKeys.filter { masterKey in
            wallets.first(where: { $0.masterKeyID == masterKey.id }) != nil
        }
        guard walletStore.save(masterKeys: masterKeys) else {
            self.error = "Couldn't save wallets"
            return
        }
        walletStore.save(wallets: wallets)
    }
}

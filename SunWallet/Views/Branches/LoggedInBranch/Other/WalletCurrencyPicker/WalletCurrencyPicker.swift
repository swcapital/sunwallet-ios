import SwiftUI

struct WalletCurrencyPicker: View {
    let masterKeys: [MasterKey]
    let showBalances: Bool
    let completion: () -> Void
    
    @EnvironmentObject var portfolioStore: WalletsHistoryStore
    @EnvironmentObject var walletStore: WalletStore
    
    @State private var wallets: [Wallet] = []
    @State private var isLoading: Bool = false
    @State private var error: String?
    @State private var walletsHistory: WalletsHistory?
    @State private var selection: Set<Wallet> = []
    
    private var canContinue: Bool { !selection.isEmpty }
    
    private var continueButton: some View {
        Button("Continue") {
            self.saveData()
            self.completion()
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
        Group {
            if wallets.isEmpty {
                Text("There is no new wallets")
                    .font(.title)
            } else {
                VStack(spacing: 16) {
                    walletList
                    
                    Spacer()
                    
                    continueButton
                        .padding(.horizontal)
                }
            }
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
            let wallets = self.availableWallets()
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
        portfolioStore.walletsHistory(wallets: wallets) {
            self.walletsHistory = $0
            self.isLoading = false
        }
    }
    
    private func balance(for wallet: Wallet) -> Double? {
        guard showBalances else { return nil }
        let history = walletsHistory?.first(where: { $0.wallet == wallet })
        return history?.totalEquity ?? 0
    }
    
    private func saveData() {
        let wallets = Array(selection)
        
        let masterKeys = self.masterKeys.filter { masterKey in
            wallets.first(where: { $0.masterKeyID == masterKey.id }) != nil
        }
        guard walletStore.add(masterKeys: masterKeys) else {
            self.error = "Couldn't save wallets"
            return
        }
        walletStore.add(wallets: wallets)
    }
    
    private func availableWallets() -> [Wallet] {
        let addresses = walletStore.wallets.map(\.address)
        return masterKeys.map { $0.wallets() }
            .reduce([], +)
            .filter { !addresses.contains($0.address) }
            .sorted()
    }
}

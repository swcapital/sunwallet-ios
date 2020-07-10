import SwiftUI

struct BootstrapWalletsView: View {
    // MARK:- Environment
    @EnvironmentObject
    var userStateStore: UserStateStore
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State private var showNewWalletSheet = false
    @State private var error: String?
    
    private var addWalletButton: some View {
        Button(action: { self.showNewWalletSheet = true }) {
            Image(systemName: "plus.circle")
        }
        .frame(width: 30, height: 30)
    }
    private var continueButton: some View {
        Button("Continue") { self.userStateStore.logIn() }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(walletStore.wallets.isEmpty)
    }
    private var emptyView: some View {
        VStack(spacing: 32) {
            Text("You don't have any wallets yet. Please create one at first.")
                .font(.largeTitle)
            
            ORView()
            
            Button("Restore from Keychain") {
                if !self.walletStore.restoreWallets() {
                    self.error = "You don't have previously stored Master Keys"
                }
            }
            .frame(maxWidth: .infinity)
        }
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
    private var walletsList: some View {
        VStack {
            Divider()
            ForEach(walletStore.wallets, id: \.self) { wallet in
                VStack {
                    HStack {
                        wallet.currency.asset.imageName.map { Image($0) }
                        VStack(alignment: .leading) {
                            Text("Address: \(wallet.address)")
                                .lineLimit(1)
                                .font(.headline)
                            Text("Master Key: \(self.masterKey(for: wallet)?.title ?? "Unknown")")
                                .lineLimit(1)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    Divider()
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if walletStore.wallets.isEmpty {
                    emptyView
                } else {
                    walletsList
                }
                
                Spacer(minLength: 64)
                
                continueButton
            }
            .navigationBarItems(trailing: addWalletButton)
            .padding(.horizontal)
            .padding(.bottom, 48)
        }
        .sheet(isPresented: $showNewWalletSheet) {
            AddWalletView(completion: { self.showNewWalletSheet = false })
                .environmentObject(self.walletStore)
        }
    }
    
    private func masterKey(for wallet: Wallet) -> MasterKeyInfo? {
        walletStore.masterKeys.first(where: { wallet.masterKeyID == $0.id })
    }
}

struct ImportedWalletsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BootstrapWalletsView()
                .environmentObject(WalletStore())
        }
    }
}

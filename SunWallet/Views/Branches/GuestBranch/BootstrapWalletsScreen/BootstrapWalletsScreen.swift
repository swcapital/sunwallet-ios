import SwiftUI

struct BootstrapWalletsScreen: View {
    // MARK:- Environment
    @EnvironmentObject
    var appStateStore: AppStateStore
    
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
        Button("Continue") { self.appStateStore.logIn() }
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if walletStore.wallets.isEmpty {
                    emptyView
                } else {
                    WalletList()
                }
                
                Spacer(minLength: 64)
                
                continueButton
            }
            .navigationBarItems(trailing: addWalletButton)
            .padding(.horizontal)
            .padding(.bottom, 48)
        }
        .sheet(isPresented: $showNewWalletSheet) {
            AddWalletScreen(completion: { self.showNewWalletSheet = false })
                .environmentObject(self.walletStore)
        }
    }
    
    
}

struct ImportedWalletsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BootstrapWalletsScreen()
                .environmentObject(WalletStore())
        }
    }
}

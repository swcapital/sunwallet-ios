import SwiftUI

struct BootstrapWalletsScreen: View {
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var restoredMasterKeys: [MasterKey] = []
    
    @State
    private var error: String?
    
    @State
    private var useRestoredMasterKeys: Bool = false
    
    private var importWalletsButton: some View {
        return NavigationLink("Import Wallets", destination: ImportWalletScreen())
            .buttonStyle(PrimaryButtonStyle())
    }
    private var createWalletButton: some View {
        let destination = LazyView(
            WalletCurrencyPicker(masterKeys: [MasterKey()], showBalances: false)
        )
        return NavigationLink("Create Wallets", destination: destination)
            .buttonStyle(PrimaryButtonStyle())
    }
    private var restoreWalletsButton: some View {
        let destination = WalletCurrencyPicker(masterKeys: restoredMasterKeys, showBalances: true)
        return VStack {
            NavigationLink(destination: destination, isActive: $useRestoredMasterKeys) {
                EmptyView()
            }
            
            Button("Restore from Keychain") {
                self.restoreFromKeychain()
            }
        }
        
    }
    private var buttonsBlock: some View {
        VStack {
            createWalletButton
            
            ORView()
            
            importWalletsButton
            
            ORView()
            
            restoreWalletsButton
        }
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 32.0) {
                Text("You don't have any wallets yet")
                    .font(.title)
                
                buttonsBlock
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitle("Create wallet")
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
    
    private func restoreFromKeychain() {
        let masterKeys = walletStore.loadMasterKeys(hint: "Restore previous Master Keys")
        if let masterKeys = masterKeys, masterKeys.count > 0 {
            self.restoredMasterKeys = masterKeys
            self.useRestoredMasterKeys = true
        } else {
            self.error = "You don't have previously stored Master Keys"
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

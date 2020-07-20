import SwiftUI

struct BootstrapWalletsScreen: View {
    // MARK:- Environment    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State private var actionState: ActionState?
    @State private var error: String?
    @State private var restoredMasterKeys: [MasterKey] = []
    
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
            NavigationLink(destination: destination, tag: ActionState.restored, selection: $actionState) {
                EmptyView()
            }
            Button("Restore from Keychain") {
                let masterKeys = self.walletStore.loadMasterKeys(hint: "Restore previous Master Keys")
                if masterKeys.count > 0 {
                    self.restoredMasterKeys = masterKeys
                    self.actionState = .restored
                } else {
                    self.error = "You don't have previously stored Master Keys"
                }
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
        ScrollView {
            VStack(alignment: .leading, spacing: 32.0) {
                Text("You don't have any wallets yet")
                    .font(.title)
                
                buttonsBlock
            }
            .padding(.horizontal)
            .padding(.bottom, 48)
        }
        .navigationBarTitle("Create wallet")
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
}

extension BootstrapWalletsScreen {
    private enum ActionState: Int {
        case restored
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

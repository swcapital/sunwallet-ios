import SwiftUI

struct BootstrapWalletsScreen: View {
    // MARK:- Environment
    @ObservedObject
    private var viewModel: ViewModel = .init()
    
    private var importWalletsButton: some View {
        return NavigationLink("Import Wallets", destination: ImportWalletScreen())
            .buttonStyle(PrimaryButtonStyle())
    }
    private var createWalletButton: some View {
        let destination = LazyView(
            WalletCurrencyPicker(masterKeys: [self.viewModel.newMasterKey()], showBalances: false)
        )
        return NavigationLink("Create Wallets", destination: destination)
            .buttonStyle(PrimaryButtonStyle())
    }
    private var restoreWalletsButton: some View {
        let destination = WalletCurrencyPicker(masterKeys: viewModel.restoredMasterKeys, showBalances: true)
        return VStack {
            NavigationLink(destination: destination, isActive: $viewModel.useRestoreMasterKeys) {
                EmptyView()
            }
            
            Button("Restore from Keychain") {
                self.viewModel.restoreFromKeychain()
            }
            .accentColor(.primary)
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
        .alert(item: $viewModel.error) { error in
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

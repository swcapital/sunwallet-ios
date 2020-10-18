import SwiftUI

struct SignupView: View {
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var appStateStore: AppStateStore
    
    @State private var restoredMasterKeys: [MasterKey] = []
    @State private var error: String?
    @State private var useRestoredMasterKeys: Bool = false
    
    @State private var email: String = ""
    
    private var importWalletsButton: some View {
        NavigationLink("Import Wallets", destination: ImportWalletScreen(completion: { self.appStateStore.logIn() }))
            .buttonStyle(PrimaryButtonStyle())
    }
    private var createWalletButton: some View {
        let destination = LazyView(
            WalletCurrencyPicker(masterKeys: [MasterKey()], showBalances: false, completion: { self.appStateStore.logIn() })
        )
        return NavigationLink("Create Wallets", destination: destination)
            .buttonStyle(PrimaryButtonStyle())
    }

    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            createWalletButton
        }
        .navigationBarTitle("Enter your Email")
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignupView()
                .environmentObject(WalletStore())
        }
    }
}

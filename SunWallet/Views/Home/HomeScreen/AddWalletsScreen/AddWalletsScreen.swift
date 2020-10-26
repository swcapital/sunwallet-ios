import SwiftUI

struct AddWalletsScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var importWalletsButton: some View {
        NavigationLink("Import Wallets", destination: ImportWalletScreen(completion: dismiss))
            .buttonStyle(PrimaryButtonStyle())
    }
    private var createWalletButton: some View {
        let destination = LazyView(
            WalletCurrencyPicker(masterKeys: [MasterKey()], showBalances: false, completion: self.dismiss)
        )
        return NavigationLink("Create Wallets", destination: destination)
            .buttonStyle(PrimaryButtonStyle())
    }
    
    var body: some View {
        VStack {
            createWalletButton
            
            ORView()
            
            importWalletsButton
        }
        .padding()
        .navigationBarTitle("Add wallet")
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddWalletsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletsScreen()
    }
}

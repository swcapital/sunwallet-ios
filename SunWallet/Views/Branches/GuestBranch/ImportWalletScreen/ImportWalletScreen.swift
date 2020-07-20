import SwiftUI

struct ImportWalletScreen: View {
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var text: String = ""
    
    private var importWalletButton: some View {
        let destination = LazyView(
            WalletCurrencyPicker(masterKeys: [MasterKey(mnemonic: self.text)], showBalances: true)
        )
        return NavigationLink("Next", destination: destination)
            .buttonStyle(PrimaryButtonStyle())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter recovery phrase")
                .font(.title)
            
            TextView(text: $text)
                .frame(height: 200)
                .cornerRadius(16)
            
            Text("This is 12 word phrase you were given when you created you previous wallet.")
                .font(.caption)
            
            Spacer()
            
            importWalletButton
        }
        .padding(.horizontal)
        .padding(.bottom, 48)
        .navigationBarTitle("Add wallet")
    }
}

struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ImportWalletScreen()
            .environmentObject(WalletStore())
    }
}

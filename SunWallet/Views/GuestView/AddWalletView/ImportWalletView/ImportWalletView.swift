import SwiftUI

struct ImportWalletView: View {
    let completion: () -> Void
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var text: String = ""
    
    @State
    private var showCurrencyPicker = false
    
    @State
    private var selection: Set<WalletCurrency> = []
    
    @State
    private var error: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter recovery phrase")
                .font(.title)
            
            TextView(text: $text)
                .frame(height: 200)
                .cornerRadius(16)
            
            Text("This is 12 word phrase you were given when you created you previous wallet.")
                .font(.caption)
            
            Button("Import") { self.showCurrencyPicker = true }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 32)
        }
        .sheet(isPresented: $showCurrencyPicker) {
            VStack {
                WalletCurrencyPicker(selection: self.$selection)
                
                Button("Next") { self.importWallets() }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, 32)
            }
            .padding()
            .environmentObject(self.walletStore)                
        }
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
    
    func importWallets() {
        if walletStore.importWallets(for: Array(selection), mnemonic: text) {
            showCurrencyPicker = false
            completion()
        } else {
            error = "Error creating wallets"
        }
    }
}

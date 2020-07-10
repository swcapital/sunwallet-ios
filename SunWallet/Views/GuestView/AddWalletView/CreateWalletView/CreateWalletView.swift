import SwiftUI

struct CreateWalletView: View {
    let completion: () -> Void
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var selection: Set<WalletCurrency> = []
    
    @State
    private var error: String?
    
    var body: some View {
        VStack {
            WalletCurrencyPicker(selection: $selection)
            
            Text("You can find the Recovery phrase later, after creation, in Settings")
                .font(.callout)
                .padding()

            Spacer()

            Button("Create") { self.createWallets() }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .disabled(self.selection.isEmpty)
        }
        .padding(.vertical, 32)
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
    
    private func createWallets() {
        if walletStore.createWallets(for: Array(selection)) {
            completion()
        } else {
            error = "Error creating wallets"
        }
    }
}

struct CreateWalletView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateWalletView(completion: { })
        }
    }
}

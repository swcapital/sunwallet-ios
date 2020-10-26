import SwiftUI

struct ImportWalletScreen: View {
    let completion: () -> Void
        
    @State private var text: String = ""
    
    private var importWalletButton: some View {
        NavigationLink(
            "Next",
            destination: WalletCurrencyPicker(
                masterKeys: [MasterKey(mnemonic: text)],
                showBalances: true,
                completion: completion
            )
        )
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

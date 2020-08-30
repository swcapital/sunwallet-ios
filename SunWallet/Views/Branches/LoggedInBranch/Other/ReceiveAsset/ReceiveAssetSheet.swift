import SwiftUI

struct ReceiveAssetSheet: View {
    let accounts: [Account]
    
    // MARK:- Bindings
    @Binding var selectedAccount: Account?
    

    var body: some View {
        List {
            Text("Select asset")
                .padding(.horizontal)
                .font(.headline)
            
            ForEach(accounts) { account in
                ReceiveAssetCell(asset: account.asset)
                    .onTapGesture {
                        self.selectedAccount = account
                    }
                }
            }
    }
}

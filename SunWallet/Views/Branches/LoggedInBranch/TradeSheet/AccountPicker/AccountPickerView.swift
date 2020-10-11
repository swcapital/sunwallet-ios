import SwiftUI

struct AccountPickerView: View {
    let accounts: [Account]
    
    // MARK:- Bindings
    @Binding var selectedAccount: Account?
    
    var grouppedAccounts: [Wallet: [Account]] {
        Dictionary(grouping: accounts, by: { $0.wallet })
    }
    
    var body: some View {
        
        VStack {
            Text("Select asset")
                .padding(.horizontal)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                ForEach(grouppedAccounts.keys.sorted(), id: \.self) { wallet in
                    Section(header: Text(wallet.title).font(.headline)) {
                        ForEach(self.grouppedAccounts[wallet]!) { account in
                            AccountCell(account: account)
                                .onTapGesture {
                                    self.selectedAccount = account
                                }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

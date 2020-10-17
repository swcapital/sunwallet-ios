import SwiftUI

struct ReceiveAssetScreen: View {
    let accounts: [Account]
    @State private var selectedAccount: Account
    
    init(accounts: [Account]) {
        self.accounts = accounts
        self._selectedAccount = .init(initialValue: accounts.first!)
    }
    
    // MARK:- States
    @State private var showAccountsView = false
    
    // MARK:- Calculated Variables
    private var selectedAccountProxy: Binding<Account?> {
        .init(
            get: { self.selectedAccount },
            set: { newValue in
                withAnimation {
                    self.showAccountsView = false
                    if let newValue = newValue {
                        self.selectedAccount = newValue
                    }
                }
            }
        )
    }
    
    // MARK:- Subviews
    private var accountsView: some View {
        BottomSheetView(isOpen: $showAccountsView) {
            AccountPickerView(accounts: accounts, selectedAccount: selectedAccountProxy)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
        }
    }
    private var changeAccountButton: some View {
        Button(animationAction: { self.showAccountsView = true }) {
            AccountCell(account: selectedAccount)
                .padding(.horizontal)
                .roundedBorder()
        }
    }
    private var mainView: some View {
        VStack {
            Text("Receive \(selectedAccount.asset.title)")
                .font(.headline)
                .padding(.top, 32)
            
            QRView(address: selectedAccount.wallet.address)
                .padding()
            
            changeAccountButton
                .padding()
            
            Button("Share address") {
                let address = self.selectedAccount.wallet.address
                print(address)
                self.share(items: [address])
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top)
    }
    
    var body: some View {
        ZStack {
            mainView
            
            if showAccountsView {
                accountsView
            }
        }
    }
}

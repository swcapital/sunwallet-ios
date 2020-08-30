import SwiftUI

struct ReceiveAssetView: View {
    // MARK:- Environment
    @EnvironmentObject var walletStore: WalletStore 
    
    // MARK:- States
    @State private var selectedAccount: Account?
    @State private var showWalletView = false
    
    // MARK:- Calculated Variables
    private var accounts: [Account] {
        walletStore.wallets.map { $0.accounts }.reduce([], +)
    }
    private var currentAccount: Account? {
        selectedAccount ?? accounts.first
    }
    
    // MARK:- Subviews
    private var walletView: some View {
        Group {
            if showWalletView {
                BottomSheetView(isOpen: $showWalletView) {
                    ReceiveAssetSheet(
                        accounts: accounts,
                        selectedAccount: .init(
                            get: { self.selectedAccount },
                            set: { newValue in
                                withAnimation {
                                    self.showWalletView = false
                                    self.selectedAccount = newValue
                                }
                            }
                        )
                    )
                    .frame(height: 300)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    private var roundedBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
    }
    
    var body: some View {
        currentAccount.map { account in
            VStack {
                Text("Receive \(account.asset.title)")
                    .font(.headline)
                    .padding(.top, 32)
                
                QRView(address: account.wallet.address)
                    .padding()

                Button(action: { self.showWalletView = true }) {
                    ReceiveAssetCell(asset: account.asset)
                        .overlay(roundedBorder)
                }
                .padding()
                
                Button("Share address") {
                    guard let address = self.selectedAccount?.wallet.address else { return }
                    self.share(items: [address])
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(walletView)
        }
    }
}

private extension Wallet {
    
    private var assets: [Asset] {
        [asset] + (asset == .eth ? Asset.etherTokens : [])
    }
    
    var accounts: [Account] {
        assets.map { Account(wallet: self, asset: $0) }
    }
}

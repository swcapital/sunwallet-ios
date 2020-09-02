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
    private var currentAccount: Account {
        selectedAccount ?? accounts.first!
    }
    
    // MARK:- Subviews
    private var walletView: some View {
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
            .frame(maxWidth: .infinity)
        }
    }
    private var roundedBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
    }
    private var mainView: some View {
        VStack {
            Text("Receive \(currentAccount.asset.title)")
                .font(.headline)
                .padding(.top, 32)
            
            QRView(address: currentAccount.wallet.address)
                .padding()
            
            Button(animationAction: { self.showWalletView = true }) {
                ReceiveAssetCell(asset: currentAccount.asset)
                    .padding(.horizontal)
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
        .padding(.top)
    }
    
    var body: some View {
        ZStack {
            mainView
            
            if showWalletView {
                walletView
            }
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

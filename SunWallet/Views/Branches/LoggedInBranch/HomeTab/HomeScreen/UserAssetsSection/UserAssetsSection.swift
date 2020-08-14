import SwiftUI

struct UserAssetsSection: View {
    let walletsHistory: [Wallet: WalletHistory]
    
    // MARK:- Calculated Variables
    private var wallets: [Wallet] {
        Array(walletsHistory.keys)
    }
    
    private func destination(for wallet: Wallet) -> some View {
        WalletDetailsScreen(wallet: wallet, walletHistory: self.walletsHistory[wallet]!)
    }
    
    var body: some View {
        Section() {
            Divider()
            ForEach(wallets) { wallet in
                NavigationLink(destination: self.destination(for: wallet)) {
                    Cell(wallet: wallet, walletHistory: self.walletsHistory[wallet]!)
                        .contentShape(Rectangle())
                    Divider()
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(GroupedListStyle())
        }
    }
}

import SwiftUI

struct UserAssetsSection: View {
    let walletsHistory: [Wallet: WalletHistory]
    
    // MARK:- Calculated Variables
    private var wallets: [Wallet] {
        Array(walletsHistory.keys)
    }
    
    var body: some View {
        Section() {
            Divider()
            ForEach(wallets) { wallet in
                NavigationLink(destination: Text("")) {//CoinDetailsScreen(asset: wallet.asset)) {
                    Cell(wallet: wallet, walletHistory: self.walletsHistory[wallet]!)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(GroupedListStyle())
        }
    }
}

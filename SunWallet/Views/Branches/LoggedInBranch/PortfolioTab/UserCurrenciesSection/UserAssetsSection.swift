import SwiftUI

extension PortfolioScreen {
    struct UserAssetsSection: View {
        let balances: [Wallet: Double]
        
        // MARK:- Calculated Variables
        private var wallets: [Wallet] {
            Array(balances.keys)
        }
        
        var body: some View {
            Section() {
                ForEach(wallets) { wallet in
                    NavigationLink(destination: Text("")) {//CoinDetailsScreen(asset: wallet.asset)) {
                        Cell(wallet: wallet, balance: self.balances[wallet, default: 0])
                            .foregroundColor(.primary)
                    }
                    
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}

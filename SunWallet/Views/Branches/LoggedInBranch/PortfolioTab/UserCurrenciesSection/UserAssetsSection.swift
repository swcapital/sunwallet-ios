import SwiftUI

extension PortfolioScreen {
    struct UserAssetsSection: View {
        // MARK:- Environment
        @EnvironmentObject var blockchainStore: BlockchainStore
        
        // MARK:- Calculated Variables
        private var wallets: [Wallet] {
            Array(blockchainStore.balances.keys)
        }
        
        var body: some View {
            Section() {
                ForEach(wallets, id: \.address) { wallet in
                    NavigationLink(destination: Text("")) {//CoinDetailsScreen(asset: wallet.asset)) {
                        Cell(wallet: wallet)
                            .foregroundColor(.primary)
                    }
                    
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}

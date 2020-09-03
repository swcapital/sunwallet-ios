import SwiftUI

struct UserAssetsSection: View {
    let walletsHistory: WalletsHistory
    
    @EnvironmentObject var walletStore: WalletStore
        
    init(walletsHistory: WalletsHistory) {
        self.walletsHistory = walletsHistory
    }
        
    var body: some View {
        VStack {
            Divider()
            
            ForEach(walletStore.wallets.sorted()) { wallet in
                self.history(for: wallet).map { walletHistory in
                    VStack {
                        NavigationLink(destination: WalletDetailsScreen(walletHistory: walletHistory, wallet: wallet)) {
                            Cell(wallet: wallet, walletHistory: walletHistory)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
    
    func history(for wallet: Wallet) -> WalletHistory? {
        walletsHistory.first(where: { $0.wallet.address == wallet.address })
    }
}

import SwiftUI

struct UserAssetsSection: View {
    let walletsHistory: [Wallet: WalletHistory]
    private let wallets: [Wallet]
        
    init(walletsHistory: [Wallet: WalletHistory]) {
        self.walletsHistory = walletsHistory
        self.wallets = Array(walletsHistory.keys.sorted(by: { $0.address < $1.address}))
    }
    
    // MARK:- Calculated Variables
    private func destination(for wallet: Wallet) -> some View {
        WalletDetailsScreen(wallet: wallet, walletHistory: self.walletsHistory[wallet]!)
    }
    
    var body: some View {
        VStack {
            Divider()
            ForEach(wallets) { wallet in
                NavigationLink(destination: self.destination(for: wallet)) {
                    VStack {
                        Cell(wallet: wallet, walletHistory: self.walletsHistory[wallet]!)
                            .contentShape(Rectangle())
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
            }
            .listStyle(GroupedListStyle())
        }
    }
}

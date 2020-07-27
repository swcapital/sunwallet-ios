import SwiftUI

extension PortfolioScreen.UserAssetsSection {
    struct Cell: View {
        // MARK:- Properties
        let wallet: Wallet
        let walletHistory: WalletHistory
        
        var body: some View {
            VStack {
                HStack {
                    CircleIcon(radius: 40, imageName: wallet.asset.imageName)
                    
                    VStack(alignment: .leading) {
                        Text(wallet.asset.title)
                        Text(wallet.address)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Text(walletHistory.userCurrencyBalance.dollarString)
                }
                .padding(.horizontal, 16)
                
                Divider()
            }
        }
    }
}

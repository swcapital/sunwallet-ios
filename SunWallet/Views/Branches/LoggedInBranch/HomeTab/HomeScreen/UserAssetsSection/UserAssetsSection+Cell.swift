import SwiftUI

extension UserAssetsSection {
    struct Cell: View {
        // MARK:- Properties
        let wallet: Wallet
        let walletHistory: WalletHistory
        
        var body: some View {
            HStack {
                Icon(radius: 40, imageName: wallet.asset.imageName)
                
                VStack(alignment: .leading) {
                    Text(wallet.title)
                }
                
                Spacer()
                
                Text(walletHistory.totalEquity.dollarString)
            }
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
    }
}

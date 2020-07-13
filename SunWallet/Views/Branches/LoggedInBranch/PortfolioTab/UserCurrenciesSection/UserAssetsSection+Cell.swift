import SwiftUI

extension PortfolioScreen.UserAssetsSection {
    struct Cell: View {
        // MARK:- Properties
        let wallet: Wallet
        
        // MARK:- Environment
        @EnvironmentObject var blockchainStore: BlockchainStore
        
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
                    
                    Text(blockchainStore.balances[wallet]!.dollarString)
                }
                .padding(.horizontal, 16)
                
                Divider()
            }
        }
    }
}

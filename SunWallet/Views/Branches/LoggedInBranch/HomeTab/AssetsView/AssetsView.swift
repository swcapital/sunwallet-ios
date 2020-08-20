import SwiftUI

struct AssetsView: View {
    let assetsHistory: [AssetHistory]
    let wallet: Wallet
    
    var body: some View {
        VStack {
            Divider()
            
            ForEach(assetsHistory) { assetHistory in
                VStack {
                    NavigationLink(
                        destination: CoinDetailsScreen(wallet: self.wallet, assetHistory: assetHistory)
                    ) {
                        Cell(assetHistory: assetHistory)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                }
            }
        }
    }
}

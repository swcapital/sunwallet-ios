import SwiftUI

struct AssetsScreen: View {
    let assetsHistory: [AssetHistory]
    let wallet: Wallet
    
    var body: some View {
        ScrollView {
            AssetsView(assetsHistory: assetsHistory, wallet: wallet)
        }
    }
}

import SwiftUI

struct UserAssetsSection: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- Calculated Variables
    private var assets: [Asset] {
        Array(dataSource.user.balance.keys)
    }
    
    var body: some View {
        Section() {
            ForEach(assets) { asset in
                NavigationLink(destination: CoinDetails(asset: asset)) {
                    PortfolioAssetCell(asset: asset)
                        .foregroundColor(.primary)
                }
                
            }
            .listStyle(GroupedListStyle())
        }
    }
}

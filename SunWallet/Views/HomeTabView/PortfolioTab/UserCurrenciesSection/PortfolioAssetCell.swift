import SwiftUI

struct PortfolioAssetCell: View {
    // MARK:- Properties
    let asset: Asset
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    var body: some View {
        VStack {
            HStack {
                CircleIcon(radius: 40, imageName: asset.imageName)
                
                Text(asset.title)
                
                Spacer()
                
                Text(dataSource.user.assetBalance(asset).dollarString)
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
    }
}

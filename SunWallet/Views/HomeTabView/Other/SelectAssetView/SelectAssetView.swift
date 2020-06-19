import SwiftUI

struct SelectAssetView: View {
    // MARK:- Properties
    let asset: Asset
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- Subviews
    private var titleView: some View {
        Text("Select asset to sell")
            .font(.headline)
    }
    private var assetCell: some View {
        HStack {
            CircleIcon(radius: 40, imageName: asset.imageName)
            
            Text("\(self.asset.code) Wallet")
                .font(.body)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(dataSource.user.dollarBalance(asset).dollarString)
                Text("\(dataSource.user.assetBalance(asset)) \(asset.code)")
                    .foregroundColor(.blueGray)
            }
            .padding(.trailing, 8)
            
            Image(systemName: "chevron.right")
        }
    }
    
    var body: some View {
        VStack {
            titleView
                .padding(8)
            
            Divider()
            assetCell
                .padding(8)
            Divider()
            Spacer()
        }
    }
}

struct SelectAssetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAssetView(asset: TestData.randomAsset)
            .environmentObject(DataSource())
    }
}

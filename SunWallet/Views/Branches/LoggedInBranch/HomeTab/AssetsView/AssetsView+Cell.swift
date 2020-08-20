import SwiftUI

extension AssetsView {
    struct Cell: View {
        let assetHistory: AssetHistory
        
        var body: some View {
            HStack {
                CircleIcon(radius: 40, imageName: assetHistory.asset.imageName)
                
                VStack(alignment: .leading) {
                    Text(assetHistory.asset.title)
                    
                    Text("\(assetHistory.balance) \(assetHistory.asset.code.uppercased())")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(assetHistory.equity.dollarString)
            }
            .padding(.horizontal, 16)
        }
    }
}

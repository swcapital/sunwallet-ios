import SwiftUI

struct ReceiveAssetCell: View {
    // MARK:- Properties
    let asset: Asset
    
    var body: some View {
        HStack(spacing: 16) {
            CircleIcon(radius: 40, imageName: asset.imageName)
            
            VStack(alignment: .leading) {
                Text(asset.title + " Wallet")
                    .foregroundColor(.black)
                Text(asset.code)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
    }
}

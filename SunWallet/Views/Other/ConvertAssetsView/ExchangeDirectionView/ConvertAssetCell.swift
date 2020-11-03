import SwiftUI

struct ConvertAssetCell: View {
    // MARK:- Properties
    let asset: Asset
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Icon(radius: 40, imageName: asset.imageName)

                Text(asset.title)
                    .foregroundColor(.black)

                Text(asset.code)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
        }
    }
}

struct ConvertCurrencyCell_Previews: PreviewProvider {
    static var previews: some View {
        ConvertAssetCell(asset: TestData.randomAsset, action: {})
    }
}

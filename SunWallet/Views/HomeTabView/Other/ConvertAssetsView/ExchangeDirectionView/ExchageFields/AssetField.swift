import SwiftUI

struct AssetField: View {
    let asset: Asset
    let title: String
    let active: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.darkGray)
                .frame(width: 50, alignment: .leading)
                .font(.body)

            CircleIcon(radius: 30, imageName: asset.imageName)

            Text(asset.title)
                .foregroundColor(active ? .blue : .black)

            Spacer()
        }
        .padding()
    }
}

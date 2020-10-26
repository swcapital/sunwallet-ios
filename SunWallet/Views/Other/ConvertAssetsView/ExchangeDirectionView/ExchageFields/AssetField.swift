import SwiftUI

struct AssetField: View {
    let asset: Asset2
    let title: String
    let active: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.darkGray)
                .frame(width: 50, alignment: .leading)
                .font(.body)

            Icon(radius: 30, imageName: asset.imageName)

            Text(asset.title)
                .foregroundColor(active ? .blue : .black)

            Spacer()
        }
        .padding()
    }
}

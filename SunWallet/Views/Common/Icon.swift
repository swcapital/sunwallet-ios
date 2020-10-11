import SwiftUI

struct Icon: View {
    let radius: CGFloat
    let imageName: String

    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .resizable()
            .frame(width: radius, height: radius)
    }
}

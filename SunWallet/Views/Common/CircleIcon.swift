import SwiftUI

struct CircleIcon<Content: View>: View {
    let radius: CGFloat
    let content: () -> Content

    var body: some View {
        content()
            .foregroundColor(Color.white)
            .frame(width: radius, height: radius)
            .background(Color.primary)
            .clipShape(Circle())
    }
}

struct CircleIcon_Previews: PreviewProvider {
    static var previews: some View {
        CircleIcon(radius: 40) { Image(systemName: "arrow.up.arrow.down") }
    }
}

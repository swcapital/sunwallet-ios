import SwiftUI

struct SWScrollView<Content: View>: View {
    // MARK:- Properties
    let subtitle: Text
    let content: () -> Content
    
    init(subtitle: Text, @ViewBuilder content: @escaping () -> Content) {
        self.subtitle = subtitle
        self.content = content
    }
    
    // MARK:- States
    @State private var offset: CGFloat = 0
    
    // MARK:- Calculated Variables
    private var subtitleOpacity: Double { Double(1 - offset / 30) }
    private var subtitleWidth: CGFloat? { offset > 10 ? 0 : nil }
    
    var body: some View {
        TrackableScrollView(
            .vertical,
            showIndicators: false,
            contentOffset: self.$offset,
            content: content
        )
        .overlay(
            subtitle.foregroundColor(.blueGray)
                .offset(x: 18, y: -65)
                .opacity(subtitleOpacity), alignment: .topLeading
        )
    }
}

struct SWScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SWScrollView(subtitle: Text("Hi everyone")) {
            Rectangle().fill(Color.red)
        }
    }
}

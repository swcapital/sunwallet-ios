import SwiftUI

struct TrackableScrollView<Content: View>: View {
    // MARK:- Properties
    let axes: Axis.Set
    let showIndicators: Bool
    let content: Content
    
    // MARK:- Bindings
    @Binding var contentOffset: CGFloat

    init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }

    var body: some View {
        GeometryReader { outside in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { inside in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: [self.contentOffset(outside: outside, inside: inside)]
                            )
                    }
                    VStack {
                        self.content
                    }
                    .padding(.bottom, 32)
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[0]
            }
        }
    }

    private func contentOffset(outside: GeometryProxy, inside: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outside.frame(in: .global).minY - inside.frame(in: .global).minY
        } else {
            return outside.frame(in: .global).minX - inside.frame(in: .global).minX
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

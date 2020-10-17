import SwiftUI

private let collapsedHeight : CGFloat = 50

struct ExpandableCell<Header: View, Content: View>: View {
    // MARK:- Properties
    let header: Header
    let content: Content
    
    init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header()
        self.content = content()
    }
    
    // MARK:- States
    @State private var expanded: Bool = false
    @State private var expandedHeight : CGFloat = .zero
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 0) {
            self.header
            Spacer()
            Image(systemName: self.expanded ? "chevron.up" : "chevron.down")
                .padding(.leading, 8)
        }
        .animation(nil)
        .contentShape(Rectangle())
        .onTapGesture() {
            withAnimation {
                self.expanded.toggle()
            }
        }
        .padding()
    }
    
    private var contentView: some View {
        content
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .animation(.default)
    }
    
    var body: some View {
        ChildHeightReader(size: $expandedHeight) {
            VStack(alignment: .leading) {
                self.headerView
                self.contentView
            }
        }
        .modifier(AnimatingCellHeight(height: expanded ? expandedHeight : collapsedHeight))
    }
}

struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0
    
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }
    
    func body(content: Content) -> some View {
        return content.frame(height: height, alignment: .top).clipped()
    }
}

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = .zero
    
    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

struct ChildHeightReader<Content: View>: View {
    @Binding var size: CGFloat
    let content: () -> Content
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                    }
                )
        }
        .onPreferenceChange(HeightPreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

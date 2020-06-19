import SwiftUI

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
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                header
                Spacer()
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
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
            if self.expanded {
                content
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .animation(.default)
            }
        }
    }
}

struct ExpandableCell_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableCell(
            header: {
                Text("Hello")
            },
            content: {
                Text("World")
            }
        )
        .background(Color.blue)
    }
}

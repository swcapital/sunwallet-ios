import SwiftUI

struct BottomSheetView<Content: View>: View {
    // MARK:- Properties
    let content: Content
    
    // MARK:- Bindings
    @Binding var isOpen: Bool
    
    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isOpen = isOpen
    }
    
    // MARK:- States
    @GestureState private var translation: CGFloat = 0

    // MARK:- Subviews
    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.secondary)
            .frame(width: 60, height: 6)
            .onTapGesture { self.isOpen.toggle() }
    }

    var body: some View {
        VStack(spacing: 0) {
            self.dragIndicator.padding()
            self.content
        }
        .background(Color.white)
        .cornerRadius(16)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .offset(y: max(translation, 0))
        .animation(.interactiveSpring())
        .gesture(
            DragGesture()
                .updating($translation) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    self.isOpen = value.translation.height < 0
                }
        )
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(true)) {
            Rectangle()
                .fill(Color.red)
                .frame(maxHeight: 400)
        }
    }
}

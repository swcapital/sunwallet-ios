import SwiftUI

extension View {
    
    func overlay<Overlay>(_ overlay: Overlay, isVisible: Bool, alignment: Alignment = .center) -> some View where Overlay : View {
        VStack {
            if isVisible {
                self.overlay(overlay, alignment: alignment)
            } else {
                self
            }
        }
    }
    
    func showLoading(_ value: Bool) -> some View {
        self.overlay(LoadingView(), isVisible: value)
    }
}

import SwiftUI

extension Button {
    init(animationAction: @escaping () -> Void, label: () -> Label) {
        self.init(action: { withAnimation { animationAction() } }, label: label)
    }
}

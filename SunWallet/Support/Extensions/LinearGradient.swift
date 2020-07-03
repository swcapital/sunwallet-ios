import SwiftUI

extension LinearGradient {
    static let background: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [.gradientStartColor, .gradientEndColor]),
        startPoint: .top,
        endPoint: .bottom
    )
}

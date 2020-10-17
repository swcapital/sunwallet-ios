import SwiftUI

struct ControlButton<Content: View>: View {
    // MARK:- Properties
    let content: Content
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            content
        }
        .font(.title)
        .frame(maxWidth: .infinity)
    }
}

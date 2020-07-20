import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    private struct Content: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: Configuration
        
        var body: some View {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        
        var backgroundColor: Color {
            if !isEnabled {
                return Color.primary.opacity(0.3)
            } else if configuration.isPressed {
                return Color.primary.opacity(0.3)
            } else {
                return Color.primary
            }
        }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Content(configuration: configuration)
    }
}

struct BlueButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            Button(action: {}) {
                Text("Hello")
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button(action: {}) {
                Text("Hello")
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(true)
        }
    }
}

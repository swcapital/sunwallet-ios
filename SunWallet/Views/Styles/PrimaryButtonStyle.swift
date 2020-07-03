import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    // MARK:- Properties
    let disabled: Bool
    
    init(disabled: Bool = false) {
        self.disabled = disabled
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(disabled || configuration.isPressed ? Color.lightBlue : .primaryBlue)
            .cornerRadius(8)
    }
}

struct BlueButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            Button(action: {}) {
                Text("Hello")
            }
            .buttonStyle(PrimaryButtonStyle(disabled: false))

            Button(action: {}) {
                Text("Hello")
            }
            .buttonStyle(PrimaryButtonStyle(disabled: true))
        }
    }
}

import SwiftUI

struct DigitButton: View {
    // MARK:- Properties
    let number: String
    let chars: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(number)
                    .font(.title)
                Text(chars)
            }
            .frame(height: 70.0)
        }
        .frame(maxWidth: .infinity)
    }
}

import SwiftUI

struct PinKeyboardView: View {
    // MARK:- Properties
    let cancelAction: () -> Void
    
    // MARK:- Bindings
    @Binding var digits: [Int]
    
    var body: some View {
        VStack {
            HStack {
                DigitButton(number: "1", chars: "") { self.append(digit: 1) }
                DigitButton(number: "2", chars: "ABC") { self.append(digit: 2) }
                DigitButton(number: "3", chars: "DEF") { self.append(digit: 3) }
            }
            
            HStack {
                DigitButton(number: "4", chars: "GHI") { self.append(digit: 4) }
                DigitButton(number: "5", chars: "JKL") { self.append(digit: 5) }
                DigitButton(number: "6", chars: "MNO") { self.append(digit: 6) }
            }

            HStack {
                DigitButton(number: "7", chars: "PQRS") { self.append(digit: 7) }
                DigitButton(number: "8", chars: "TUV") { self.append(digit: 8) }
                DigitButton(number: "9", chars: "WXYZ") { self.append(digit: 9) }
            }
            
            HStack {
                ControlButton(content: Text("cancel")) { self.cancelAction() }
                DigitButton(number: "0", chars: "") { self.append(digit: 0) }
                ControlButton(content: Image(systemName: "delete.left")) { self.removeLast() }
            }
        }
    }
    
    // MARK:- Methods
    private func append(digit: Int) {
        digits.append(digit)
    }
    
    private func removeLast() {
        guard !digits.isEmpty else { return }
        digits.removeLast()
    }
}


struct PinKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        PinKeyboardView(cancelAction: {}, digits: .constant([]))
    }
}

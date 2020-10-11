import SwiftUI

private enum KeyboardKey {
    case digit(Int)
    case dot
    case backspace
}

struct Keyboard: View {
    @Binding var keyboardNumber: KeyboardNumber
    
    var body: some View {
        VStack {
            HStack {
                makeButton(title: "1") { self.handler(.digit(1)) }
                makeButton(title: "2") { self.handler(.digit(2)) }
                makeButton(title: "3") { self.handler(.digit(3)) }
            }

            HStack {
                makeButton(title: "4") { self.handler(.digit(4)) }
                makeButton(title: "5") { self.handler(.digit(5)) }
                makeButton(title: "6") { self.handler(.digit(6)) }
            }

            HStack {
                makeButton(title: "7") { self.handler(.digit(7)) }
                makeButton(title: "8") { self.handler(.digit(8)) }
                makeButton(title: "9") { self.handler(.digit(9)) }
            }

            HStack {
                makeButton(title: Locale.current.decimalSeparator ?? ".") { self.handler(.dot) }
                makeButton(title: "0") { self.handler(.digit(0)) }
                makeButton(title: "←") { self.handler(.backspace) }
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
        .font(.largeTitle)
    }

    // MARK:- Methods
    private func handler(_ key: KeyboardKey) {
        switch key {
            case .digit(let digit):
                keyboardNumber.append(digit: digit)
            case .dot:
                keyboardNumber.setFractional()
            case .backspace:
                keyboardNumber.removeLast()
        }
        //number = keyboardNumber.doubleValue
        //label = keyboardNumber.stringValue
    }
    
    private func makeButton(title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

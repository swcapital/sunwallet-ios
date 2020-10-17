import SwiftUI

struct FocusingTextField: View {
    // MARK:- Properties
    let text: Binding<String>
    let color: Color
    let hint: String?
    let label: String
    
    init(text: Binding<String>, color: Color = .primary, hint: String? = nil, label: String = "") {
        self.text = text
        self.color = color
        self.hint = hint
        self.label = label
    }
    
    // MARK:- States
    @State private var focused: Bool = false
    
    // MARK:- Subviews
    private var textFieldBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(accentColor, lineWidth: 2)
    }
    private var accentColor: Color { focused ? color : Color.lightGray }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                label,
                text: text,
                onEditingChanged: { self.focused = $0 },
                onCommit: self.onCommit
            )
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(textFieldBorder)
            
            Text(hint ?? "")
                .foregroundColor(accentColor)
                .opacity(focused ? 1 : 0)
        }
    }
    
    // MARK:- Methods
    fileprivate func onCommit() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
    }
}

struct FocusingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FocusingTextField(text: .constant("Hello"))
    }
}

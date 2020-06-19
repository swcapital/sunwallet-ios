import SwiftUI

struct PopupButton: View {
    // MARK:- Properties
    let text: Text
    
    var body: some View {
        HStack(spacing: 0) {
            text.padding()
            Spacer()
            Divider()
            Image(systemName: "chevron.up.chevron.down")
                .font(.callout)
                .frame(maxHeight: .infinity)
                .frame(width: 30)
                .background(Color.lightGray.opacity(0.4))
        }
        .frame(height: 80)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.lightGray, lineWidth: 1)
        )
    }
}

struct PopupButton_Previews: PreviewProvider {
    static var previews: some View {
        PopupButton(text: Text("Hello"))
    }
}


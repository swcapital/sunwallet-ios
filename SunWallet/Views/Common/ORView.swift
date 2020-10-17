import SwiftUI

struct ORView: View {
    var body: some View {
        HStack(spacing: 16) {
            HorizontalLine()
            Text("OR")
            HorizontalLine()
        }
        .padding(.vertical, 16)
    }
}

struct ORView_Previews: PreviewProvider {
    static var previews: some View {
        ORView()
    }
}

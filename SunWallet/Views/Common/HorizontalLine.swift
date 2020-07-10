import SwiftUI

struct HorizontalLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.lightGray)
            .frame(height: 1)
    }
}

struct HorizontalLine_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalLine()
    }
}

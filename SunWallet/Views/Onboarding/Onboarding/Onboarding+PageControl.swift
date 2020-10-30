import SwiftUI

struct PageControl: View {
    
    var index: Int
    var count: Int
    var color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ForEach(0..<self.count) { i in
                self.color
                    .opacity(self.index == i ? 1.0 : 0.2)
                    .frame(width: 8, height: 8, alignment: .center)
                    .cornerRadius(5)
            }
        }
    }
}

struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        PageControl(index: 0, count: 3, color: Color.black)
    }
}

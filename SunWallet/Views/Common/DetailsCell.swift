import SwiftUI

struct DetailsCell: View {
    let text: Text
    
    var body: some View {
        NavigationLink(destination: Text("Details")) {
            text
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .foregroundColor(.gray)
    }
}

struct DetailsCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCell(text: Text("Hello"))
    }
}

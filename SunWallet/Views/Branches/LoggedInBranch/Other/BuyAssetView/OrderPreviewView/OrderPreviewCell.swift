import SwiftUI

struct OrderPreviewCell<Title: View, Subtitle: View>: View {
    // MARK:- Properties
    let title: Title
    let subtitle: Subtitle
    
    init(title: Title, subtitle: Subtitle) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            title
            Spacer()
            subtitle
                .foregroundColor(.blueGray)
        }
        .padding()
    }
}

struct OrderPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderPreviewCell(title: Text("Title"), subtitle: Text("Subtitle"))
    }
}

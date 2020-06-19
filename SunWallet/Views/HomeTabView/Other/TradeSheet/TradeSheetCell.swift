import SwiftUI

struct TradeSheetCell: View {
    // MARK:- Properties
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(imageName)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                }
                Spacer()
            }
            .padding()
            
            Divider()
        }
    }
}

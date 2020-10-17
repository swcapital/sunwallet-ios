import SwiftUI

struct PaymentMethodCell: View {
    let imageName: String
    let title: Text
    let subtitle: Text
    let text: Text
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        title.font(.headline)
                        subtitle.font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                text
            }
        }
        .padding()
    }
}

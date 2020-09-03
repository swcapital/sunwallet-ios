import SwiftUI

struct QRView: View {
    // MARK:- Properties
    let address: String
    private let image: Image
        
    init(address: String) {
        self.address = address
        self.image = QRCodeStore().generateImage(for: address)
    }
    
    // MARK:- Subviews
    private var cardView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(color: .lightGray, radius: 8)
    }
    private var qrImage: some View {
        image.resizable()
            .frame(width: 200, height: 200)
            .padding()
    }
    private var addressView: some View {
        VStack(alignment: .leading) {
            Text("Wallet address")
                .font(.callout)
                .foregroundColor(.blueGray)
            
            Text(address)
                .lineLimit(1)
                .truncationMode(.middle)
                .font(.body)
        }
    }
    private var copyButton: some View {
        Button("Copy") {
            self.copy(self.address)
        }
        .foregroundColor(.primary)
    }
    
    var body: some View {
        VStack {
            qrImage
            
            Divider()
            
            HStack(spacing: 32) {
                addressView
                
                copyButton
            }
            .padding()
        }
        .frame(width: 240)
        .background(cardView)
    }
}


struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView(address: "jnjdskGdsadasdVGd88")
    }
}

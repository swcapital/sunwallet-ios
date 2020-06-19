import SwiftUI

struct ExchangeDirectionButton: View {
    // MARK:- Properties
    let assetExchange: AssetExchange
    let action: () -> Void
    
    // MARK:- Subviews
    private var exchangeIcons: some View {
        ZStack {
            Circle()
                .frame(width: 45, height: 45)
                .foregroundColor(.lightGray)

            HStack(spacing: 2) {
                CircleIcon(radius: 30, imageName: assetExchange.source.imageName)

                Image(systemName: "arrow.right")
                    .foregroundColor(.darkGray)
                    .font(.caption)

                CircleIcon(radius: 30, imageName: assetExchange.destination.imageName)
            }
        }
    }
    private var popupIndicator: some View {
        VStack(spacing: 4) {
            Image(systemName: "chevron.up")
            Image(systemName: "chevron.down")
        }
        .font(.caption)
        .foregroundColor(.gray)
    }

    var body: some View {
        Button(action: action) {
            HStack {
                exchangeIcons

                VStack(alignment: .leading) {
                    Text("From \(self.assetExchange.source.title)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("To \(self.assetExchange.destination.title)")
                        .foregroundColor(.black)
                }

                Spacer()

                popupIndicator
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

struct ExchangeDirectionButton_Previews: PreviewProvider {
    static var previews: some View {
        let exchange = AssetExchange(source: TestData.randomAsset, destination: TestData.randomAsset)
        return ExchangeDirectionButton(assetExchange: exchange, action: {})
    }
}

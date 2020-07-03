import SwiftUI

struct HomeCurrencyCell: View {
    // MARK:- Properties
    let asset: Asset2
    
    var body: some View {
        VStack {
            HStack {
                CircleIcon(radius: 40, imageName: asset.imageName)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(asset.title)
                    Text(asset.code)
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text(asset.dollarPrice.dollarString)
                    Text(asset.dollarPriceChange.priceChangeString)
                        .font(.caption)
                        .foregroundColor(asset.dollarPriceChange.isPositive ? .green : .red)
                }
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
    }
}

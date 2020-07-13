import SwiftUI

struct TopMoverCell: View {
    let asset: Asset2
    
    // MARK:- Subviews
    private var overlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text(asset.dollarPriceChange.priceChangeString)
                .foregroundColor(.green)
                .font(.title)
            
            Spacer()
            
            HStack {
                CircleIcon(radius: 30, imageName: asset.imageName)
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.title)
                        .lineLimit(1)
                    Text(asset.code)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(width: 150, height: 150)
        .overlay(overlay)
        .padding(.all, 1)
    }
}

import SwiftUI

extension WatchListSection {
    struct Cell: View {
        // MARK:- Properties
        let exchangeHistory: ExchangeHistory
        
        private var asset: Asset { exchangeHistory.source }
        
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
                        Text(exchangeHistory.historySet.currentPrice.currencyString)
                        Text(exchangeHistory.historySet.currentPriceChange.priceChangeString)
                            .font(.caption)
                            .foregroundColor(exchangeHistory.historySet.currentPriceChange.isPositive ? .green : .red)
                    }
                }
                .padding(.horizontal, 16)
                
                Divider()
            }
        }
    }
}

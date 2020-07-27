import SwiftUI

extension WatchListSection {
    struct Cell: View {
        // MARK:- Properties
        let exchangeHistory: ExchangeHistory
        
        @EnvironmentObject
        var userSettingsStore: UserSettingsStore
        
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
                        Text(exchangeHistory.historySet.lastValue.currencyString(code: userSettingsStore.currency))
                        Text(exchangeHistory.historySet.lastValueDiff.priceChangeString)
                            .font(.caption)
                            .foregroundColor(exchangeHistory.historySet.lastValueDiff.isPositive ? .green : .red)
                    }
                }
                .padding(.horizontal, 16)
                
                Divider()
            }
        }
    }
}

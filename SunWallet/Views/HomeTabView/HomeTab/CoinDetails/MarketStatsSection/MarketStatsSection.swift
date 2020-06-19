import SwiftUI

struct MarketStatsSection: View {
    // MARK:- Properties
    let asset: Asset
    
    // MARK:- Calculated Variables
    private var marketStats: [MarketStat] {
        [
            .init(
                imageName: "market-capitalization",
                title: "Recources",
                value: asset.marketCap.largeNumberString,
                description: TestData.longText
            ),
            .init(
                imageName: "volume",
                title: "Volume",
                value: asset.volume.largeNumberString,
                description: TestData.longText
            ),
            .init(
                imageName: "circulating-supply",
                title: "Circulating Supply",
                value: asset.circulatingSupply.largeNumberString,
                description: TestData.longText
            ),
            .init(
                imageName: "all-time-high",
                title: "All-time high",
                value: asset.allTimeHigh.dollarString,
                description: TestData.longText
            ),
            .init(
                imageName: "trading-activity",
                title: "Trading activity",
                value: tradingActivityText,
                description: TestData.longText
            ),
            .init(
                imageName: "median-days-held",
                title: "Typical hold time",
                value: "\(asset.medianDaysHeld) days",
                description: TestData.longText
            ),
            .init(
                imageName: "popularity",
                title: "Popularity on Sun Wallet",
                value: "#\(asset.popularity)",
                description: TestData.longText
            ),
        ]
    }
    
    // MARK:- Subviews
    private var tradingActivityText: Text {
        Text(asset.tradingActivity.percentString + " buy ")
            .foregroundColor(.green) +
        Text((1 - asset.tradingActivity).percentString + " sell")
            .foregroundColor(.blueGray)
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Market Stats")
                    .font(.title)
                    .bold()
                    .padding(.leading, 16)
                    .padding(.top, 32)
                
                Divider()
                    .animation(nil)
                
                ForEach(marketStats) { marketStat in
                    MarketStatsCell(marketStat: marketStat)
                    
                    Divider()
                        .animation(nil)
                }
            }
        }
    }
}

struct MarketStatsSection_Previews: PreviewProvider {
    static var previews: some View {
        MarketStatsSection(asset: TestData.randomAsset)
    }
}

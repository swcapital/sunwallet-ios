import SwiftUI

struct CoinDetailsScreen: View {
    // MARK:- Properties
    let exchangeHistory: ExchangeHistory
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK:- States
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil

    // MARK:- Calculated Variables
    private var asset: Asset {
        exchangeHistory.source
    }
    
    private var currentValue: Double {
        selectedValue ?? exchangeHistory.historySet.currentPrice
    }
    private var currentValueChange: Double {
        selectedValueChange ?? exchangeHistory.historySet.currentPriceChange
    }
    
    // MARK:- Subviews
    private var title: Text {
        let price = Text(currentValue.currencyString(code: userSettingsStore.currency) + .extraSpace)
            .font(.largeTitle)
            .bold()
        let priceChange = Text(currentValueChange.priceChangeString)
            .font(.title)
            .bold()
            .foregroundColor(.green)
        return price + priceChange
    }
    private var subtitle: Text {
        Text("\(asset.title) price")
    }
    
    var body: some View {
        SWScrollView(title: title, subtitle: subtitle, presentationMode: presentationMode) {
            VStack(alignment: .leading, spacing: 8) {
                HistoryChartSection(
                    exchangeHistory: self.exchangeHistory,
                    color: .orange,
                    selectedValue: self.$selectedValue,
                    selectedValueChange: self.$selectedValueChange
                )
                Divider()
                BuyAssetSection(asset: self.asset)
                Divider()
                HintSection()
                Divider()
                DetailsCell(text: Text("Get Started").foregroundColor(.primaryBlue).bold())
                Divider()
                AboutSection(asset: self.asset)
                MarketStatsSection(asset: self.asset)
            }
        }
    }
}

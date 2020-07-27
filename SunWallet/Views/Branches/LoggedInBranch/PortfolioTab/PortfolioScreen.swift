import SwiftUI

struct PortfolioScreen: View {    
    // MARK:- Environment
    @EnvironmentObject
    var portfolioStore: PortfolioStore
    
    // MARK:- States
    @State
    private var selectedValue: Double? = nil
    
    @State
    private var selectedValueChange: Double? = nil
    
    @State
    private var walletsHistory: [Wallet: WalletHistory]?
    
    private var totalBalance: Double {
        walletsHistory?.values
            .map { $0.userCurrencyBalance }
            .reduce(0, +) ?? 0
    }

    // MARK:- Calculated Variables
    private var currentValue: Double {
        selectedValue ?? totalBalance
    }
    
    // MARK:- Subviews
    private var title: Text {
        Text(currentValue.dollarString)
            .font(.largeTitle)
            .bold()
    }
    private var subtitle: Text {
        Text("Balance")
    }
    private var scrollView: some View {
        SWScrollView(title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 8) {
//                HistoryChartSection(
//                    exchangeHistory: ExchangeHistory(,
//                    color: .primaryBlue,
//                    selectedValue: self.$selectedValue,
//                    selectedValueChange: self.$selectedValueChange
//                )
                Divider()
                UserAssetsSection(walletsHistory: self.walletsHistory ?? [:])
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            scrollView
                .navigationBarTitle(title)
        }
        .onReceive(portfolioStore.portfolioHistoryPublisher, perform: { self.walletsHistory = $0 })
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioScreen()
            .environmentObject(DataSource())
    }
}

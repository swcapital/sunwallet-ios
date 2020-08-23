import SwiftUI

struct HomeScreen: View {
    // MARK:- Environment
    @EnvironmentObject var portfolioStore: PortfolioStore
    
    @State private var walletsHistory: [Wallet: WalletHistory]?
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    
    private var totalEquity: Double {
        walletsHistory?.values
            .map { $0.totalEquity }
            .reduce(0, +) ?? 0
    }
    private var chartValues: HistorySet? {
        walletsHistory?.values.compactMap(\.historySet).total()
    }
    
    // MARK:- Subviews
    private var title: Text {
        Text((selectedValue ?? totalEquity).dollarString)
            .font(.largeTitle)
            .bold()
    }
    private var subtitle: Text {
        Text("Portfolio Balance")
    }
    private var scrollView: some View {
        SWScrollView(title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 8) {
                self.chartValues.map {
                    HistoryChartSection(
                        historySet: $0,
                        color: .orange,
                        selectedValue: self.$selectedValue,
                        selectedValueChange: self.$selectedValueChange
                    )
                }
                UserAssetsSection(walletsHistory: self.walletsHistory ?? [:])
                TopMoversSection()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            scrollView
        }
        .onReceive(portfolioStore.portfolioHistoryPublisher, perform: {
            self.walletsHistory = $0
        })
    }
}

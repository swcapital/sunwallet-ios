import SwiftUI

struct HomeScreen: View {
    // MARK:- Environment
    @EnvironmentObject
    var portfolioStore: PortfolioStore
    
    @EnvironmentObject
    var dataSource: DataSource
    
    @State
    private var walletsHistory: [Wallet: WalletHistory]?
    
    @State
    private var selectedValue: Double? = nil
    
    @State
    private var selectedValueChange: Double? = nil
    
    private var totalBalance: Double {
        walletsHistory?.values
            .map { $0.userCurrencyBalance }
            .reduce(0, +) ?? 0
    }
    private var chartValues: HistorySet? {
        guard let walletsHistory = walletsHistory, walletsHistory.count > 0 else {
            return nil
        }
        let sets = walletsHistory.values.map(\.historySet)
        let initialSet = sets.first!
        
        return sets.dropFirst().reduce(initialSet) {
            $0 + $1
        }
    }
    
    // MARK:- Subviews
    private var title: Text {
        Text(totalBalance.dollarString)
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
                WatchListSection()
                TopMoversSection(assets: self.dataSource.topMovers)
                PromoteSection()
                NewsSection(articles: self.dataSource.articles)
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            scrollView
        }
        .onReceive(portfolioStore.portfolioHistoryPublisher, perform: { self.walletsHistory = $0 })
    }
}

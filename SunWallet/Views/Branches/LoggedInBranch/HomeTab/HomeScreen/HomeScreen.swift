import SwiftUI

struct HomeScreen: View {
    // MARK:- Environment
    @EnvironmentObject
    var blockchainStore: BlockchainStore
    
    @EnvironmentObject
    var dataSource: DataSource
    
    @State
    private var balances: [Wallet: Double]?
    
    private var totalBalance: Double { balances?.values.reduce(0, +) ?? 0 }
    
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
        .accentColor(.primary)
        .onReceive(blockchainStore.walletsBalancePublisher, perform: { self.balances = $0 })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(DataSource())
    }
}

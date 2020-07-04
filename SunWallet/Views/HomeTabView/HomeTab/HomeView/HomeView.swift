import SwiftUI

struct HomeView: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- Subviews
    private var title: Text {
        Text(dataSource.user.totalDollarBalance.currencyString)
            .font(.largeTitle)
            .bold()
    }
    private var subtitle: Text {
        Text("Portfolio Balance")
    }
    private var scrollView: some View {
        SWScrollView(title: title, subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 8) {
                WatchListSection(assets: self.dataSource.user.favorites)
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataSource())
    }
}

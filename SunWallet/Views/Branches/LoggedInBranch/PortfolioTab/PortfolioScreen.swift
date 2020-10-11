import SwiftUI

struct PortfolioScreen: View {    
    // MARK:- Environment
    @EnvironmentObject var portfolioStore: WalletsHistoryStore
    
    // MARK:- States
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    @State private var walletsHistory: WalletsHistory?
    
    private var totalEquity: Double {
        walletsHistory?.map { $0.totalEquity }
            .reduce(0, +) ?? 0
    }

    // MARK:- Calculated Variables
    private var currentValue: Double {
        selectedValue ?? totalEquity
    }
    
    // MARK:- Subviews
    private var title: Text {
        Text(currentValue.dollarString)
    }
    private var subtitle: Text {
        Text("Balance")
    }
    private var scrollView: some View {
        SWScrollView(title: title, subtitle: subtitle) {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationView() {
            scrollView
                .navigationBarTitle(title)
        }
        .onReceive(portfolioStore.walletsHistoryPublisher, perform: { self.walletsHistory = $0 })
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioScreen()
            .environmentObject(DataSource())
    }
}

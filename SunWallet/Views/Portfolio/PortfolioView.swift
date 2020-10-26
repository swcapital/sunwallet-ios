import SwiftUI

struct PortfolioScreen: View {    
    // MARK:- Environment
    @EnvironmentObject var blockchainStore: BlockchainStore
    
    // MARK:- States
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil

    // MARK:- Calculated Variables
    private var currentValue: Double {
        selectedValue ?? blockchainStore.totalBalance
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
                UserAssetsSection()
            }
        }
    }
    
    var body: some View {
        NavigationView() {
            scrollView
                .navigationBarTitle(title)
        }
        .accentColor(.primary)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioScreen()
            .environmentObject(DataSource())
    }
}

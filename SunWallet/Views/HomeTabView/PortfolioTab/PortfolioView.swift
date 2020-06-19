import SwiftUI

struct PortfolioView: View {    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil

    // MARK:- Calculated Variables
    private var currentValue: Double {
        selectedValue ?? dataSource.user.totalDollarBalance
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
        SWScrollView(subtitle: subtitle) {
            VStack(alignment: .leading, spacing: 8) {
                ChartViewSection(
                    valueHistory: self.dataSource.user.balanceHistory,
                    color: .primaryBlue,
                    selectedValue: self.$selectedValue,
                    selectedValueChange: self.$selectedValueChange
                )
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
        PortfolioView()
            .environmentObject(DataSource())
    }
}

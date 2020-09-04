import SwiftUI

struct HomeScreen: View {
    // MARK:- Environment
    @EnvironmentObject var portfolioStore: PortfolioStore
    @EnvironmentObject var walletStore: WalletStore
    @EnvironmentObject var appStateStore: AppStateStore
    
    @State private var walletsHistory: WalletsHistory?
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    @State private var showAddingWalletSheet: Bool = false
    
    private var totalEquity: Double {
        walletsHistory?.map { $0.totalEquity }
            .reduce(0, +) ?? 0
    }
    private var chartValues: HistorySet? {
        walletsHistory?.compactMap(\.historySet).total()
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
                
                self.walletsHistory.map { UserAssetsSection(walletsHistory: $0) }
                
                TopMoversSection()
            }
        }
    }
    private var addWalletButton: some View {
        Button(action: { self.showAddingWalletSheet = true }) {
            Image(systemName: "plus")
                .resizable()
                .padding()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .background(Color.primary)
                .clipShape(Circle())
        }
        .padding(32)
        .shadow(radius: 2)
    }
    
    var body: some View {
        NavigationView {
            scrollView
        }
        .onReceive(portfolioStore.portfolioHistoryPublisher, perform: {
            self.walletsHistory = $0
        })
        .overlay(addWalletButton, alignment: .bottomTrailing)
        .sheet(isPresented: $showAddingWalletSheet) {
            NavigationView {
                AddWalletsScreen()
            }
            .environmentObject(self.portfolioStore)
            .environmentObject(self.walletStore)
        }
    }
}

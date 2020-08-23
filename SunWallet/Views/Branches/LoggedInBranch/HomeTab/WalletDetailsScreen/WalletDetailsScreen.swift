import SwiftUI

struct WalletDetailsScreen: View {
    let wallet: Wallet
    let walletHistory: WalletHistory
        
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    
    private var totalEquity: Double {
        walletHistory.totalEquity
    }
    private var chartValues: HistorySet? {
        walletHistory.historySet
    }
    private var assetsHistory: [AssetHistory] {
        walletHistory.assetsHistory.sorted(by: { $0.equity > $1.equity })
    }
    private var largestAssets: [AssetHistory] {
        assetsHistory.prefix(5).array()
    }
    private var newestTransactions: [AssetTransaction] {
        walletHistory.transactions.sorted().prefix(5).array()
    }
    
    // MARK:- Subviews
    private var balance: Text {
        Text((selectedValue ?? totalEquity).dollarString)
            .font(.largeTitle)
            .bold()
    }
    private var titleView: some View {
        VStack(alignment: .leading) {
            Text("Wallet balance")
                .foregroundColor(.blueGray)
            balance
                .font(.largeTitle)
        }
    }
    private var assetList: some View {
        VStack {
            HStack {
                Text("Assets")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(
                    "See all",
                    destination: AssetsScreen(assetsHistory: assetsHistory, wallet: wallet)
                )
            }
            .padding(.horizontal)
                        
            AssetsView(assetsHistory: largestAssets, wallet: wallet)
        }
    }
    private var transactionList: some View {
        VStack {
            HStack {
                Text("History")
                    .font(.headline)
                    
                
                Spacer()
                
                NavigationLink(
                    "See all",
                    destination: TransactionsScreen(transactions: walletHistory.transactions.sorted())
                )
            }
            .padding(.horizontal)
            
            TransactionsView(transactions: newestTransactions)
        }
    }
    private var scrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                titleView
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                
                self.chartValues.map {
                    HistoryChartSection(
                        historySet: $0,
                        color: .orange,
                        selectedValue: self.$selectedValue,
                        selectedValueChange: self.$selectedValueChange
                    )
                }
                
                assetList
                
                transactionList
                    .padding(.top, 32)
            }
        }
    }
    
    var body: some View {
        scrollView
            .navigationBarTitle(wallet.asset.title)
    }
}

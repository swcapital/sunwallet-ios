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
            Divider()
            ForEach(assetsHistory.indices, id: \.self) { i in
                VStack {
                    Cell(assetHistory: self.assetsHistory[i])
                    Divider()
                }
            }
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
            }
        }
    }
    
    var body: some View {
        scrollView
            .navigationBarTitle(wallet.asset.title)
    }
}

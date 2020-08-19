import SwiftUI

struct CoinDetailsScreen: View {
    // MARK:- Properties
    let wallet: Wallet
    let assetHistory: AssetHistory
    
    @EnvironmentObject private var userSettingsStore: UserSettingsStore
    @EnvironmentObject private var historyStore: HistoryStore
    @EnvironmentObject private var blockchainStore: BlockchainStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK:- States
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    @State private var history: ExchangeHistory?
    @State private var walletBalance: WalletBalance?

    // MARK:- Calculated Variables
    private var asset: Asset {
        assetHistory.asset
    }
    private var currentValue: Double {
        selectedValue ?? history?.historySet.lastValue ?? 0
    }
    private var currentValueChange: Double {
        selectedValueChange ?? history?.historySet.lastValueDiff ?? 0
    }
    private var assetBalance: AssetBalance? {
        walletBalance?.assets.first(where: { $0.asset == assetHistory.asset })
    }
    
    // MARK:- Subviews
    private var titleView: some View {
        VStack(alignment: .leading) {
            Text("\(asset.title) price history")
                .foregroundColor(.blueGray)
            
            Text(currentValue.dollarString)
                .font(.largeTitle)
        }
    }
    private var transactionList: some View {
        assetBalance.map { assetBalance in
            VStack {
                Divider()
                ForEach(assetBalance.transactions.indices) { i in
                    VStack {
                        TransactionCell(transaction: assetBalance.transactions[i])
                        Divider()
                    }
                }
            }
        }
    }
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 8) {
                titleView
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                
                self.history.map {
                    HistoryChartSection(
                        historySet: $0.historySet,
                        color: .orange,
                        selectedValue: self.$selectedValue,
                        selectedValueChange: self.$selectedValueChange
                    )
                }
                
                transactionList
                
                AboutSection(asset: self.asset)                
            }
        }
        .onReceive(historyStore.publisher(for: .all)) {
            self.history = $0?.first(where: { $0.source == self.assetHistory.asset })
        }
        .onReceive(blockchainStore.walletsInfoPublisher(wallets: [wallet])) {
            self.walletBalance = $0?[self.wallet]
        }
    }
}

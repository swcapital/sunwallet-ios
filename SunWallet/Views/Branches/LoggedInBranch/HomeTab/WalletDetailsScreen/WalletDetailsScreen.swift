import SwiftUI

private enum AlertType: Identifiable {
    case mnemonic(String)
    case removeWallet
    
    var id: Int {
        switch self {
        case .mnemonic: return 0
        case .removeWallet: return 1
        }
    }
}

struct WalletDetailsScreen: View {
    let walletHistory: WalletHistory
    
    @EnvironmentObject var walletStore: WalletStore
        
    @State var wallet: Wallet
    @State private var selectedValue: Double? = nil
    @State private var selectedValueChange: Double? = nil
    @State private var showingActionSheet = false
    @State private var alertType: AlertType?
    
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
    private var walletSettingsButton: some View {
        Button(action: { self.showingActionSheet = true }) {
            Image(systemName: "ellipsis")
        }
    }
    private var renameButton: Alert.Button {
        .default(Text("Rename")) {
            self.showRenameDialog()
        }
    }
    private var showMnemonicButton: Alert.Button {
        .default(Text("Show Recovery Phrase")) {
            guard let masterkeys = self.walletStore.loadMasterKeys(hint: "Access for recovery phrase") else { return }
            guard let masterkey = masterkeys.first(where: { $0.id == self.wallet.masterKeyID }) else { return }
            self.alertType = .mnemonic(masterkey.mnemonic)
        }
    }
    private var deleteButton: Alert.Button {
        .destructive(Text("Delete")) {
            self.alertType = .removeWallet
        }
    }
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("Wallet's actions"), message: Text(wallet.title), buttons: [renameButton, showMnemonicButton, deleteButton, .cancel()])
    }
    private var removeAlert: Alert {
        Alert(
            title: Text("Are you sure you want to delete this wallet"),
            primaryButton: Alert.Button.destructive(Text("Delete"), action: removeWallet),
            secondaryButton: Alert.Button.cancel()
        )
    }
    
    var body: some View {
        scrollView
            .navigationBarTitle(wallet.title)
            .navigationBarItems(trailing: walletSettingsButton)
            .alert(item: self.$alertType) { alertType in
                switch alertType {
                case .mnemonic(let phrase): return mnemonicAlert(phrase)
                case .removeWallet: return removeAlert
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                self.actionSheet
            }
    }
    
    private func mnemonicAlert(_ mnemonic: String) -> Alert {
        Alert(
            title: Text("Recovery phrase"),
            message: Text(mnemonic),
            primaryButton: Alert.Button.default(Text("Copy"), action: { Pasteboard.copy(mnemonic) }),
            secondaryButton: Alert.Button.cancel(Text("Close"))
        )
    }
    
    private func showRenameDialog() {
        let alertController = UIAlertController(title: "Rename Wallet", message: wallet.title, preferredStyle: .alert)
        
        alertController.addTextField() {
            $0.text = self.wallet.title
        }
        
        alertController.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            let textField = alertController.textFields![0] as UITextField
            let title = textField.text ?? "Wallet"
            self.renameWallet(title)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        self.present(alertController)
    }
    
    private func renameWallet(_ title: String) {
        var wallets = walletStore.wallets
        let index = wallets.firstIndex(of: wallet)!
        wallets[index].title = title
        wallet.title = title
        walletStore.save(wallets: wallets)
    }
    
    private func removeWallet() {
        walletStore.remove(wallet: wallet)
    }
}

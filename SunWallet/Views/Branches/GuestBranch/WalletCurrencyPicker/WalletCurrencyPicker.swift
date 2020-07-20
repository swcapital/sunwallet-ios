import SwiftUI

struct WalletCurrencyPicker: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @ObservedObject
    private var viewModel: ViewModel
    
    @State
    private var selection: Set<Wallet>
    
    init(masterKeys: [MasterKey], showBalances: Bool) {
        let viewModel = ViewModel(masterKeys: masterKeys, showBalances: showBalances)
        self.viewModel = viewModel
        self._selection = .init(initialValue: Set(viewModel.wallets))
    }
    
    private var continueButton: some View {
        Button("Continue") {
            self.viewModel.save(wallets: Array(self.selection))
            self.appStateStore.logIn()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(self.selection.isEmpty)
    }
    
    private var walletList: some View {
        ScrollView {
            Divider()
            ForEach(viewModel.wallets) { wallet in
                Cell(
                    wallet: wallet,
                    balance: self.viewModel.balance(for: wallet),
                    selection: self.$selection
                )
                .padding(.horizontal)
                
                Divider()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            walletList
            
            Spacer()
            
            continueButton
                .padding(.horizontal)
        }
        .padding(.bottom, 48)
        .alert(item: self.$viewModel.error) { error in
            Alert(title: Text(error))
        }
        .onAppear(perform: viewModel.onAppear)
        .showLoading(viewModel.isLoading)
    }
}

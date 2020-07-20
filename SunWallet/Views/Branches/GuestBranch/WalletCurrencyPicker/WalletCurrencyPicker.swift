import SwiftUI

struct WalletCurrencyPicker: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @ObservedObject
    private var viewModel: ViewModel
    
    init(masterKeys: [MasterKey], showBalances: Bool) {
        self.viewModel = ViewModel(masterKeys: masterKeys, showBalances: showBalances)
    }
    
    private var continueButton: some View {
        Button("Continue") {
            self.viewModel.saveData()
            self.appStateStore.logIn()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!viewModel.canContinue)
    }
    
    private var walletList: some View {
        ScrollView {
            Divider()
            ForEach(viewModel.wallets) { wallet in
                Cell(
                    wallet: wallet,
                    balance: self.viewModel.balance(for: wallet),
                    selection: self.$viewModel.selection
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
        .showLoading(viewModel.isLoading)
    }
}

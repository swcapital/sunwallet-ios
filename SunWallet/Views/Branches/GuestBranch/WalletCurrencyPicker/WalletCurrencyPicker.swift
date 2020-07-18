import SwiftUI

struct WalletCurrencyPicker: View {
    private let wallets: [Wallet]
    
    let masterKeys: [MasterKey]
    let showAddresses: Bool
    
    init(masterKeys: [MasterKey], showAddresses: Bool) {
        self.masterKeys = masterKeys
        self.showAddresses = showAddresses
        
        let wallets = masterKeys.map { $0.wallets() }.reduce([], +)
        self.wallets = wallets
        self._selection = .init(initialValue: Set(wallets))
    }
    
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    @State
    private var selection: Set<Wallet>
    
    @State
    private var error: String?
    
    private var continueButton: some View {
        Button("Continue") {
            let masterKeys = self.masterKeys.filter { masterKey in
                self.wallets.first(where: { $0.masterKeyID == masterKey.id }) != nil
            }
            guard self.walletStore.save(masterKeys: masterKeys) else {
                self.error = "Couldn't save wallets"
                return
            }
            self.walletStore.save(wallets: Array(self.selection))
            self.appStateStore.logIn()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(self.selection.isEmpty)
    }
    
    private var walletList: some View {
        ScrollView {
            Divider()
            ForEach(wallets.indices) { index in
                Cell(
                    wallet: self.wallets[index],
                    showAddress: self.showAddresses,
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
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
    }
}

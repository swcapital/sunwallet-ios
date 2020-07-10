import SwiftUI

struct ChooseMasterKeysView: View {
    let currencies: [WalletCurrency]
    
    @EnvironmentObject
    var walletStore: WalletStore
    
    var body: some View {
        ForEach(currencies, id: \.self) { currency in
            ForEach(self.walletStore.availableMasterKeys(for: currency), id: \.self) { masterKey in
                Text(masterKey.title)
            }
        }
    }
}

struct ChooseMasterKeysView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseMasterKeysView(currencies: [.btc, .eth])
            .environmentObject(WalletStore())
    }
}

import SwiftUI

struct WalletCurrencyPicker: View {
    @Binding var selection: Set<WalletCurrency>
    
    var body: some View {
        VStack {
            Divider()
            ForEach(WalletCurrency.allCases.indices) { index in
                Cell(currency: WalletCurrency.allCases[index], selection: self.$selection)
                    .padding(.horizontal)
                Divider()
            }
        }
    }
}

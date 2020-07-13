import SwiftUI

let availableAssets: [Asset] = [.btc, .eth]

struct WalletCurrencyPicker: View {
    @Binding var selection: Set<Asset>
    
    var body: some View {
        VStack {
            Divider()
            ForEach(availableAssets.indices) { index in
                Cell(asset: availableAssets[index], selection: self.$selection)
                    .padding(.horizontal)
                Divider()
            }
        }
    }
}

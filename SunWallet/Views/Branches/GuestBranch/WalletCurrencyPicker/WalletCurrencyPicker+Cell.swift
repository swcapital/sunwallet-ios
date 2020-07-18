import SwiftUI

extension WalletCurrencyPicker {
    struct Cell: View {
        let wallet: Wallet
        let showAddress: Bool
        @Binding var selection: Set<Wallet>
        
        private var isSelected: Bool { selection.contains(wallet) }
        
        private var selectionImage: some View {
            Image(systemName: isSelected ? "checkmark.circle.fill": "circle")
                .font(.system(size: 25, weight: .light))
                .foregroundColor(.primary)
        }
        
        var body: some View {
            HStack {
                Image(wallet.asset.imageName)
                Text(self.showAddress ? wallet.address : wallet.asset.title)
                Spacer()
                selectionImage
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture { self.toggleSelection() }
        }
        
        func toggleSelection() {
            if isSelected {
                selection.remove(wallet)
            } else {
                selection.insert(wallet)
            }
        }
    }
}

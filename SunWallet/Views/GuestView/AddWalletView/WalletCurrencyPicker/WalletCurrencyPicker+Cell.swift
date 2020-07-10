import SwiftUI

extension WalletCurrencyPicker {
    struct Cell: View {
        let currency: WalletCurrency
        @Binding var selection: Set<WalletCurrency>
        
        private var isSelected: Bool { selection.contains(currency) }
        
        private var selectionImage: some View {
            Image(systemName: isSelected ? "checkmark.circle": "circle")
                .font(.system(size: 25, weight: .light))
                .foregroundColor(.primaryBlue)
        }
        
        var body: some View {
            HStack {
                currency.asset.imageName.map { Image($0) }
                Text(currency.asset.title)
                Spacer()
                selectionImage
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture { self.toggleSelection() }
        }
        
        func toggleSelection() {
            if isSelected {
                selection.remove(currency)
            } else {
                selection.insert(currency)
            }
        }
    }
}

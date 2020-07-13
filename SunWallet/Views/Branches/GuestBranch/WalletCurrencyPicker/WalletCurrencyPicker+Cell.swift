import SwiftUI

extension WalletCurrencyPicker {
    struct Cell: View {
        let asset: Asset
        @Binding var selection: Set<Asset>
        
        private var isSelected: Bool { selection.contains(asset) }
        
        private var selectionImage: some View {
            Image(systemName: isSelected ? "checkmark.circle": "circle")
                .font(.system(size: 25, weight: .light))
                .foregroundColor(.primaryBlue)
        }
        
        var body: some View {
            HStack {
                Image(asset.imageName)
                Text(asset.title)
                Spacer()
                selectionImage
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture { self.toggleSelection() }
        }
        
        func toggleSelection() {
            if isSelected {
                selection.remove(asset)
            } else {
                selection.insert(asset)
            }
        }
    }
}

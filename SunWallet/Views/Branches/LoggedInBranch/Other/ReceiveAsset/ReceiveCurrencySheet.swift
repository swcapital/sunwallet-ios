import SwiftUI

struct ReceiveAssetSheet: View {
    // MARK:- Bindings
    @Binding var asset: Asset
    @Binding var isOpen: Bool
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select asset")
                .padding(.horizontal)
                .font(.headline)
            
            Divider()
            
            List {
                ForEach(dataSource.assets) { asset in
                    ReceiveAssetCell(asset: asset)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.asset = asset
                            self.isOpen = false
                        }
                }
            }
        }
    }
}

struct ReceiveCurrencySheet_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveAssetSheet(asset: .constant(TestData.randomAsset), isOpen: .constant(true))
    }
}

import SwiftUI

struct ReceiveAsset: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var asset: Asset = TestData.randomAsset
    @State private var showWalletView = false
    
    // MARK:- Calculated Variables
    private var walletAddress: String {
        dataSource.user.walletAddress(asset)
    }
    
    // MARK:- Subviews
    private var walletView: some View {
        VStack {
            if showWalletView {
                BottomSheetView(isOpen: $showWalletView) {
                    ReceiveAssetSheet(asset: self.$asset, isOpen: $showWalletView)
                        .frame(height: 300)
                }
            }
        }
    }
    private var roundedBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
    }
    private var spacer: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 16)
            .padding()
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Receive \(asset.title)")
                .font(.headline)
                .padding()
            
            QRView(address: walletAddress)
            
            spacer
            
            Button(action: { self.showWalletView = true }) {
                ReceiveAssetCell(asset: asset)
                    .overlay(roundedBorder)
            }
            
            Button("Share address") {
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay(walletView)
    }
}

struct ReceiveAsset_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveAsset()
            .environmentObject(DataSource())
    }
}

import SwiftUI

struct BuyAssetSection: View {
    // MARK:- Properties
    let asset: Asset
    
    // MARK:- Subviews
    private var buyButton: some View {
        Button("Buy") {}
            .buttonStyle(PrimaryButtonStyle())
    }
    private var assetCell: some View {
        HStack {
            Icon(radius: 40, imageName: asset.imageName)
            
            Text("\(self.asset.code) Wallet")
                .font(.body)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                //Text(dataSource.user.dollarBalance(asset).currencyString)
                Text("Fix Me")
                //Text("\(dataSource.user.assetBalance(asset)) \(asset.code)")
                    .foregroundColor(.blueGray)
            }
            .padding(.trailing, 8)
            
            Image(systemName: "chevron.right")
        }
    }
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                assetCell
                    .padding()
                
                buyButton
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
        }
    }
}


struct BuyCurrencySection_Previews: PreviewProvider {
    static var previews: some View {
        BuyAssetSection(asset: .btc)
            .environmentObject(DataSource())
    }
}

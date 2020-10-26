import SwiftUI

struct WalletDetailCell: View {
    // MARK:- Properties
    let asset: Asset2
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
    // MARK:- Calculated Variables
    private var balance: Double { dataSource.user.assetBalance(asset) }
    private var dollarBalance: Double { dataSource.user.dollarBalance(asset) }
    
    var body: some View {
        HStack(spacing: 16) {
            Icon(radius: 40, imageName: "wallet-details-convert")
                .foregroundColor(.orange)
            
            VStack(alignment: .leading) {
                Text("Sent Bitcoin")
                    .foregroundColor(.black)
                Text(asset.code)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(balance.decimalString)
                    .foregroundColor(balance.isPositive ? .green : .black)
                
                Text(dollarBalance.currencyString(code: userSettingsStore.currency))
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

struct WalletDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        WalletDetailCell(asset: TestData.randomAsset)
            .environmentObject(DataSource())
    }
}

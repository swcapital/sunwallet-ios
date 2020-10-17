import SwiftUI

struct AccountCell: View {
    // MARK:- Properties
    let account: Account
    
    var body: some View {
        HStack(spacing: 16) {
            Icon(radius: 40, imageName: account.asset.imageName)
            
            VStack(alignment: .leading) {
                Text(account.asset.title + " Wallet")
                    .foregroundColor(.black)
                
                Text(account.asset.code.uppercased())
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(account.equity.dollarString)
                    .foregroundColor(.black)
                
                Text(account.amount.currencyString(code: account.asset.code.uppercased()))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

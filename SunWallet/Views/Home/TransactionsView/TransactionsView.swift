import SwiftUI

struct TransactionsView: View {
    let transactions: [AssetTransaction]
    
    var body: some View {
        VStack {
            Divider()
            
            ForEach(transactions) { transaction in
                VStack {
                    Cell(transaction: transaction)
                    Divider()
                }
            }
        }
    }
}

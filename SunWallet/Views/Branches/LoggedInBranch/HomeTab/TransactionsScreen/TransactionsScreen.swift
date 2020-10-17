import SwiftUI

struct TransactionsScreen: View {
    let transactions: [AssetTransaction]
    
    var body: some View {
        ScrollView {
            TransactionsView(transactions: transactions)
        }
    }
}

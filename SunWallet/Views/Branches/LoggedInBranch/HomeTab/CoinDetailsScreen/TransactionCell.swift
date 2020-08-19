import SwiftUI

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

extension CoinDetailsScreen {
    struct TransactionCell: View {
        let transaction: Transaction
        
        var body: some View {
            HStack {
                Text(formatter.string(from: transaction.date))
                Spacer()
                Text("\(transaction.value)")
            }
            .padding()
        }
    }
}

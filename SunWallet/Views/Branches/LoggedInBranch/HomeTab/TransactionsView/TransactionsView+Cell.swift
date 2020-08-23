import SwiftUI

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

extension TransactionsView {
    struct Cell: View {
        let transaction: AssetTransaction
        
        private var stringSign: String {
            transaction.value.isPositive ? "+" : "-"
        }
        
        var body: some View {
            HStack {
                CircleIcon(radius: 40, imageName: transaction.asset.imageName)
                
                VStack(alignment: .leading) {
                    Text(transaction.value.isPositive ? "Received" : "Sent")
                    
                    Text(formatter.string(from: transaction.date))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(stringSign)\(abs(transaction.value)) \(transaction.asset.code.uppercased())")
                    
                    Text(stringSign + abs(transaction.currencyValue).dollarString)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
        }
    }
}

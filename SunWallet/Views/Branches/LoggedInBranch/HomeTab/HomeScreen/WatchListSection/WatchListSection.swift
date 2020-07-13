import SwiftUI

struct WatchListSection: View {
    // MARK:- Properties
    let exchangeHistories: [ExchangeHistory]
    
    // MARK:- Subviews
    private var header: some View {
        Text("Watchlist")
            .font(.title)
            .padding(16)
    }
    
    var body: some View {
        Section(header: header) {
            Divider()
            ForEach(exchangeHistories, id: \.source.code) { history in
                NavigationLink(destination: CoinDetailsScreen(exchangeHistory: history)) {
                    Cell(exchangeHistory: history)
                        .foregroundColor(.primary)
                }
                
            }
            .listStyle(GroupedListStyle())
        }
    }
}

import SwiftUI

struct WatchListSection: View {
    @EnvironmentObject
    var historyStore: HistoryStore
    
    @State
    private var exchangeHistories: [ExchangeHistory] = []
    
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
                }
                .buttonStyle(PlainButtonStyle()) 
                
            }
            .listStyle(GroupedListStyle())
        }
        .onReceive(historyStore.publisher(for: .favorites)) { self.exchangeHistories = $0 ?? [] }
    }
}

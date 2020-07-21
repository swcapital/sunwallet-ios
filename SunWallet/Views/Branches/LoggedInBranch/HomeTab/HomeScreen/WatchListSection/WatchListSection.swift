import SwiftUI

struct WatchListSection: View {
    // MARK:- Properties
    @State
    private var exchangeHistories: [ExchangeHistory] = []
    
    @EnvironmentObject
    var historyStore: HistoryStore
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
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
        .onAppear(perform: loadIfNeeded)
    }
    
    func loadIfNeeded() {
        historyStore.history(targets: userSettingsStore.favorites) {
            self.exchangeHistories = $0
        }
    }
}

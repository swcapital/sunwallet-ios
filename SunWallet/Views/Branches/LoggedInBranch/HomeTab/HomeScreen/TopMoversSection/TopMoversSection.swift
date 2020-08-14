import SwiftUI

struct TopMoversSection: View {
    @EnvironmentObject var historyStore: HistoryStore
    
    @State private var exchangeHistory: [ExchangeHistory]?
    
    // MARK:- Subviews
    private var header: some View {
        Text("Top Movers")
            .font(.title)
            .padding(16)
    }
    private func makeItems(exchangeHistory: [ExchangeHistory]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(exchangeHistory.indices, id: \.self) { i in
                    TopMoverCell(history: exchangeHistory[i])
                }
            }
            .padding(.top, 10)
        }
        .frame(height: 160)
    }
    
    var body: some View {
        Section(header: header) {
            exchangeHistory.map { exchangeHistory in
                makeItems(exchangeHistory: exchangeHistory)
            }
        }
        .onReceive(historyStore.publisher(for: .all)) {
            let newValue = $0?.sorted(
                by: { $0.historySet.daily.growth() > $1.historySet.daily.growth() }
            )
            .prefix(5)
            .array()
            
            if newValue != self.exchangeHistory {
                self.exchangeHistory = newValue
            }
        }
    }
}

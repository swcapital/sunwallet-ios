import SwiftUI

private let targets: [Asset] = [.btc, .bch, .eth, .init("etc"), .init("ltc")]

struct GuestBranch: View {
    @EnvironmentObject
    var historyStore: HistoryStore
    
    private var isLoading: Bool { history == nil }
    
    @State
    private var history: [ExchangeHistory]?
    
    var body: some View {
        Group {
            history.map { history in
                NavigationView {
                    WelcomeScreen(history: history)
                }
            }
            if isLoading {
                LoadingScreen()
            }
        }
        .onReceive(historyStore.publisher(for: .bootstrap)) { self.history = $0 }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestBranch()
    }
}

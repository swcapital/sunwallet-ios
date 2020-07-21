import SwiftUI

private let targets: [Asset] = [.btc, .bch, .eth, .init("etc"), .init("ltc")]

struct GuestBranch: View {
    @EnvironmentObject
    var historyStore: HistoryStore
    
    @State
    private var isLoading: Bool = false
    
    @State
    private var history: [ExchangeHistory]?
    
    var body: some View {
        Group {
            history.map { history in
                NavigationView {
                    WelcomeScreen(assets: history)
                }
            }
            if isLoading {
                LoadingScreen()
            }
        }
        .onAppear(perform: loadIfNeeded)
    }
    
    func loadIfNeeded() {
        guard !isLoading, history == nil else { return }
        
        isLoading = true
        historyStore.history(targets: targets) {
            self.history = $0
            self.isLoading = false
        }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestBranch()
    }
}

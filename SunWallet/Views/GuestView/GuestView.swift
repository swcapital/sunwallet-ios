import SwiftUI

struct GuestView: View {
    @EnvironmentObject
    var historyStore: BootstrapHistoryStore
    
    var body: some View {
        switch historyStore.state {
        case .loading:
            return AnyView(LoadingView())
        case .loaded(let pairs):
            return AnyView(
                NavigationView {
                    WelcomeView(assets: pairs)
                }
            )
        case .none:
            historyStore.loadIfNeeded()
            return AnyView(EmptyView())
        }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestView()
    }
}

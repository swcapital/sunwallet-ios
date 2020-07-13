import SwiftUI

struct GuestBranch: View {
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(LoadingScreen())
        case .loaded(let pairs):
            return AnyView(
                NavigationView {
                    WelcomeScreen(assets: pairs)
                }
            )
        case .none:
            viewModel.loadIfNeeded()
            return AnyView(EmptyView())
        }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestBranch()
    }
}

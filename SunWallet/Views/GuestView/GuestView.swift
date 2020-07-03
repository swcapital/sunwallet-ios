import SwiftUI

struct GuestView: View {
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(LoadingView())
        case .loaded(let pairs):
            return AnyView(WelcomeView(assets: pairs))
        case .error(let error):
            return AnyView(Text(error))
        }
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        GuestView()
    }
}

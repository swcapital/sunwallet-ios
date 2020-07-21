import SwiftUI

struct RootView: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @ViewBuilder
    var body: some View {
        Group {
            if appStateStore.loggedIn {
                LoggedInBranch()
            } else {
                GuestBranch()
            }
        }
        .accentColor(.primary)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

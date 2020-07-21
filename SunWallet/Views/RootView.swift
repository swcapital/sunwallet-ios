import SwiftUI

struct RootView: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @ViewBuilder
    var body: some View {
        if appStateStore.loggedIn {
            LoggedInBranch()
        } else {
            GuestBranch()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

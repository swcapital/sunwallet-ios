import SwiftUI

struct RootView: View {
    @EnvironmentObject
    var userStateStore: UserStateStore
    
    @ViewBuilder
    var body: some View {
         if userStateStore.loggedIn {
            HomeTabView()
        } else {
            GuestView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

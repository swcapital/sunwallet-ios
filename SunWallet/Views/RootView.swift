import SwiftUI

struct RootView: View {
    private let historyStore = BootstrapHistoryStore()
    private let walletStore = WalletStore()
    
    @EnvironmentObject
    var userStateStore: UserStateStore
    
    @ViewBuilder
    var body: some View {
         if userStateStore.loggedIn {
            HomeTabView()
                .environmentObject(DataSource())
        } else {
            GuestView()
                .environmentObject(historyStore)
                .environmentObject(walletStore)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

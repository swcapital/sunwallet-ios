import SwiftUI

struct RootView: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    @State var onboardingComplete: Bool = false
    
    @ViewBuilder
    var body: some View {
        Group {
            if appStateStore.loggedIn {
                MainView()
            } else {
                OnboardingView(finished: $onboardingComplete)
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

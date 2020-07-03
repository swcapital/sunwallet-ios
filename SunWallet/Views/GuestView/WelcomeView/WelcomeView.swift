import SwiftUI

struct WelcomeView: View {
    // MARK:- Properties
    let assets: [TradePairHistory]
    
    // MARK:- Environment
    @EnvironmentObject var appState: AppState
    
    // MARK:- Subviews
    private var registerButton: some View {
        Button("Get Started") {
            self.appState.loggedIn = true
        }
        .foregroundColor(.gradientEndColor)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
    }
    private var loginButton: some View {
        Button("Sign In") {
        }
        .foregroundColor(.white)
    }
    private var buttonsBlock: some View {
        VStack(spacing: 8) {
            registerButton
                .padding(.horizontal)
            loginButton
                .padding()
        }
    }
    
    var body: some View {
        VStack {
            LogoView()
            AssetsView(assets: assets)
            Spacer()
            buttonsBlock
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.background)
        .edgesIgnoringSafeArea(.all)
    }
}

import SwiftUI

struct WelcomeView: View {
    let assets: [TradePairHistory]
    
    // MARK:- Subviews
    private var registerButton: some View {
        Button(action: {}) {
            Text("Get Started")
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

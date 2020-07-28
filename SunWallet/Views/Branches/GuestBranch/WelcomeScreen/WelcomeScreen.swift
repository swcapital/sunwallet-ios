import SwiftUI

struct WelcomeScreen: View {
    // MARK:- Properties
    let history: [ExchangeHistory]
    
    // MARK:- Subviews
    private var registerButton: some View {
        NavigationLink(destination: BootstrapWalletsScreen()) {
            Text("Get Started")
                .padding()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .foregroundColor(.gradientEndColor)
                .background(Color.white)
                .cornerRadius(8)
        }
    }
    
    var body: some View {
        VStack {
            LogoView()
            
            AssetsChart(history: history)
            
            Spacer()
            
            registerButton
                .padding(.horizontal)
        }
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.background)
        .edgesIgnoringSafeArea(.all)
    }
}

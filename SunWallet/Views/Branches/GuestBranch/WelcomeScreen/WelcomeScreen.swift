import SwiftUI

struct WelcomeScreen: View {
    // MARK:- Properties
    // MARK:- Subviews
    private var registerButton: some View {
        NavigationLink(destination: SignupView()) {
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
            Divider()
                .background(Color.white)
            
            Spacer()
            
            ScrollView {
                LazyHStack {
                    PageView()
                }
            }
            
            Spacer()
            
            registerButton
                .padding(.horizontal)
        }
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AnimatedGradientView())
        .edgesIgnoringSafeArea(.all)
    }
}

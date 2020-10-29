import SwiftUI
import MagicSDK
import MagicExt_OAuth

struct OnboardingView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            OnboardingLogoView()
            
            Divider()
                .background(Color.black)
            
            OnboardingTitleView()
                        
            //Spacer()


            Spacer()
            
            
            SignInWithApple()
                .frame(width: 280, height: 40)
                .onTapGesture(perform: showAppleLogin)
            /*
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }) {
                Text("Continue")
                    .customButton()
            }*/
        }
        .padding(.horizontal)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK:- Methods
extension OnboardingView {
    private func showAppleLogin() {
        let configuration = OAuthConfiguration(provider: .APPLE, redirectURI: "sunwallet://")
        
        Magic.shared.oauth.loginWithPopup(configuration, response: {response in
            guard let result = response.result else { return print("Error:", response.error.debugDescription) }
            print("DIDToken", result.magic.idToken)
        })
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

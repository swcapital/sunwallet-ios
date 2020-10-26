import SwiftUI

struct OnboardingView: View {
        
    var body: some View {
        VStack(alignment: .center) {
            OnboardingLogoView()
            
            Divider()
                .background(Color.black)
                        
            
            
            ScrollView {
                OnboardingTitleView()
                
                InformationContainerView()
            }
            
            //Spacer()


            Spacer()

            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }) {
                Text("Continue")
                    .customButton()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct GuestView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

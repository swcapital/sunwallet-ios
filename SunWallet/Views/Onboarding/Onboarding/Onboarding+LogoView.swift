import SwiftUI

struct OnboardingLogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 64)
            .padding()
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingLogoView()
    }
}

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading. Please wait...")
                .foregroundColor(.white)
            ActivityIndicator(animating: .constant(true))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient.background)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

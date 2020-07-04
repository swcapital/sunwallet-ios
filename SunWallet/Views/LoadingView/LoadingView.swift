import SwiftUI

struct LoadingView: View {
    private let images = (1...359).map { String(format: "a-frame_%03d", $0) }.map { Image($0) }
    
    var body: some View {
        AnimatingImage(images: images)
            .padding(32)
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

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(.sRGB, white: 0, opacity: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Rectangle()
                .fill(Color.primary)
                .frame(width: 120, height: 120)
                .cornerRadius(12)
            
            ActivityIndicator(animating: .constant(true))
        }
        .edgesIgnoringSafeArea(.all)
        .scaledToFill()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.init(.sRGB, white: 0, opacity: 0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .fill(Color.init(.sRGB, white: 0, opacity: 0.5))
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            ActivityIndicator(animating: .constant(true))
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

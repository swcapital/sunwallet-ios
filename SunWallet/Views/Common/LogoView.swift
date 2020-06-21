import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding()
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}

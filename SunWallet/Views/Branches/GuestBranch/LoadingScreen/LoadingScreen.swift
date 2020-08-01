import SwiftUI

struct LoadingScreen<Background: View>: View {
    private let images = (1...180).map { String(format: "loading_%03d", $0) }.map { Image($0) }
    
    let background: Background
    
    var body: some View {
        AnimatingImage(images: images, interval: 0.04)
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background)
            .edgesIgnoringSafeArea(.all)
    }
}

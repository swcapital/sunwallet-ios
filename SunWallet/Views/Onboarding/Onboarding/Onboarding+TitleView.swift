import SwiftUI

struct OnboardingTitleView: View {
    private var assetNames = ["Bitcoin", "Ethereum", "Tokens", "DeFi", "High APRs", "The Future of Finance"]
    @State var assetCounter = 0
    @State var assetName = "Bitcoin."
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Get Started with")
                .fontWeight(.regular)
                .font(.system(size: 32))
            
            AnimatedText($assetName, charDuration: 0.07) { text in
                text
                .fontWeight(.black)
                .font(.system(size: 32))
                .foregroundColor(.primary)
                
            }
            .lineLimit(2)
            .onReceive(timer) { input in
                assetCounter += 1
                if assetCounter == assetNames.count {
                    assetCounter = 0
                }
                assetName = assetNames[assetCounter] + "."
            }
        }
        
    }
}

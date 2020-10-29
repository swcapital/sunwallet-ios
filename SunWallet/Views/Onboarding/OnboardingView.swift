import SwiftUI
import MagicSDK
import MagicExt_OAuth

struct OnboardingView: View {
    
    @Binding var finished: Bool
    
    @State var index: Int = 0
    @State var count: Int = 3
    
    // MODIFY THESE VARIABLES TO CHANGE THE ONBOARDING SCREEN
    var imageNames: [String] = ["38", "40", "51"]
    var titles: [String] = ["Get started with Bitcoin", "Loem Ipsum", "Loem Ipsum"]
    var descriptions: [String] = ["Sun Wallet is your easy start into the world of cryptocurrencies.", "Lorem ipsum dolor sit amet. Consecteteuer adipiscing elit.", "Lorem ipsum dolor sit amet. Consecteteuer adipiscing elit."]
    
    var blobStartColor: Color = Color(red: 202/255.0, green: 254/255.0, blue: 255/255.0)
    var blobEndColor: Color = Color.blueColor
    
    var pageControlColor: Color = Color.blueColor
    
    var titleColor: Color = Color.blueColor
    var detailColor: Color = Color.lightBlueColor
        
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Blob()
                        .fill(LinearGradient(gradient: Gradient(colors: [self.blobStartColor, self.blobEndColor]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height/3.0, alignment: .center)
                        .offset(x: getBlobXOffset(pageIndex: self.index, proxy: geometry), y: -70)
                    Spacer()
                    Blob()
                        .fill(LinearGradient(gradient: Gradient(colors: [self.blobStartColor, self.blobEndColor]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height/3.0, alignment: .center)
                        .offset(x: getBlobXOffset(pageIndex: self.index, proxy: geometry), y: -70)
                        .rotationEffect(Angle(degrees: 180))
                }
                .offset(x: getBlobStackOffset(proxy: geometry))
                .edgesIgnoringSafeArea(.vertical)
                .shadow(color: self.blobStartColor.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack {
                    HStack(alignment: .center, spacing: 0){
                            ForEach(0..<self.count) { i in
                            VStack(alignment: .center, spacing: 0) {
                                Image(self.imageNames[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 280, height: 320, alignment: .center)
                                Text(self.titles[i])
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(self.titleColor)
                                    .padding(.horizontal, 20)
                                Text(self.descriptions[i])
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 18/255, green: 31/255, blue: 71/255).opacity(0.4))
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                            }.frame(width: geometry.size.width, height: nil, alignment: .center)
                             
                            }
                    }.offset(x: getItemOffset(pageIndex: self.index, proxy: geometry), y: -20)
                    
                    
                    PageControl(index: self.index, count: self.count, color: self.pageControlColor)
                        .frame(width: nil, height: 20, alignment: .center)
                        .padding(.bottom, 20)
                        .offset(x: getBlobStackOffset(proxy: geometry))
                    
                    Button(action: {
                        showAppleLogin()
                    }) {
                        HStack {
                            Image("bookmark.fill")
                            Text("Login with Apple")
                        }
                        .customButton()
                    }.frame(width: 280, height: 40, alignment: .center)
                    .offset(x: getBlobStackOffset(proxy: geometry))
                    
                }
            }.gesture(DragGesture()
                .onChanged({ value in
                    let dx = (value.startLocation.x - value.location.x) * -1
                    self.dragOffset = dx
                })
                .onEnded({ value in
                    let rawPosition = (geometry.size.width * CGFloat(self.index - 1) * -1) +  self.dragOffset
                    
                    let fullWidth = geometry.size.width * CGFloat(self.count)
                    
                    let finalPosition = (fullWidth / 2.0) - rawPosition
                    
                    var newIndex = Int(finalPosition / (fullWidth / CGFloat(self.count) ) )
                    
                    if newIndex >= self.count {
                        newIndex = self.count - 1
                    }
                    if newIndex < 0 {
                        newIndex = 0
                    }
                    
                    withAnimation {
                        self.dragOffset = 0
                        self.index = newIndex
                    }
                    
                    print(rawPosition, fullWidth, newIndex)
                })
            )
        }
        
        
    }
    
    // Must account for changes in iOS 14.0 GeometryReader alignment changes
    func getItemOffset(pageIndex: Int, proxy: GeometryProxy) -> CGFloat {
        if #available(iOS 14.0, *) {
            return (proxy.size.width * CGFloat(self.index) * -1) +  self.dragOffset
        } else {
            return (proxy.size.width * CGFloat(self.index - 1) * -1) +  self.dragOffset
        }
    }
    
    func getBlobXOffset(pageIndex: Int, proxy: GeometryProxy) -> CGFloat {
        return (proxy.size.width/3.0) + ((proxy.size.width * CGFloat(self.index - 1) * -1) +  self.dragOffset) * 0.1
    }
    
    func getBlobStackOffset(proxy: GeometryProxy) -> CGFloat {
        if #available(iOS 14.0, *) {
            return -1 * proxy.size.width
        } else {
            return 0
        }
    }
}

// MARK:- Methods
extension OnboardingView {
    private func showAppleLogin() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let configuration = OAuthConfiguration(provider: .APPLE, redirectURI: "sunwallet://")
        
        Magic.shared.oauth.loginWithPopup(configuration, response: {response in
            self.finished = true
            guard let result = response.result else { return print("Error:", response.error.debugDescription) }
            print("DIDToken", result.magic.idToken)
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var finished: Bool = false
    static var previews: some View {
        OnboardingView(finished: $finished)
    }
}

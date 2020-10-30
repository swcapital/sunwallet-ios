import SwiftUI
import MagicSDK
import MagicExt_OAuth

struct OnboardingView: View {
    
    @Binding var finished: Bool
    @State var index: Int = 0
    @State var count: Int = 3
    @State var position: CGFloat = 0
    
    var imageNames: [String] = ["38", "40", "51"]
    var titles: [LocalizedStringKey] = ["Get started with Crypto", "Be your own Bank", "Earn Interest & Invest"]
    var descriptions: [LocalizedStringKey] = ["Sun Wallet is your easy start into the world of cryptocurrencies.", "Instantly buy & sell cryptocurrencies and store them securely on your phone.", "Earn high interest rates on your crypto holdings and discover the world of decentralized finance."]
    
    var blobStartColor: Color = Color(red: 20.0/255.0, green: 18.0/255.0, blue: 89.0/255.0)
    var blobEndColor: Color = Color(red: 45.0/255.0, green: 40.0/255.0, blue: 198.0/255.0)
    
    var pageControlColor: Color = Color(red: 3.0/255.0, green: 53.0/255.0, blue: 151.0/255.0)
    
    var titleColor: Color = Color(red: 3.0/255.0, green: 53.0/255.0, blue: 151.0/255.0)
    var detailColor: Color = Color(red: 36.0/255.0, green: 53.0/255.0, blue: 87.0/255.0)
        
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Blob()
                        .fill(LinearGradient(gradient: Gradient(colors: [self.blobStartColor, self.blobEndColor]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height/3.0, alignment: .center)
                        .offset(x: getBlobXOffset(pageIndex: self.index, proxy: geometry), y: -100)
                    Spacer()
                    Blob()
                        .fill(LinearGradient(gradient: Gradient(colors: [self.blobStartColor, self.blobEndColor]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height/3.0, alignment: .center)
                        .offset(x: getBlobXOffset(pageIndex: self.index, proxy: geometry), y: -100)
                        .rotationEffect(Angle(degrees: 180))
                }
                .offset(x: getBlobStackOffset(proxy: geometry))
                .edgesIgnoringSafeArea(.vertical)
                .shadow(color: self.blobStartColor.opacity(0.5), radius: 10, x: 0, y: 0)
                
                VStack {
                    HStack(alignment: .center, spacing: 0){
                            ForEach(0..<self.count) { i in
                            VStack(alignment: .center, spacing: 16) {
                                Image(self.imageNames[i])
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 32)
                                                                    
                                Text(self.titles[i])
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(self.titleColor)
                                    .padding(.horizontal, 16)
                                
                                Text(self.descriptions[i])
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 18/255, green: 31/255, blue: 71/255).opacity(0.4))
                                    .padding(.horizontal, 16)
                            }.frame(width: geometry.size.width, height: nil, alignment: .center)
                             
                            }
                    }.offset(x: getItemOffset(pageIndex: self.index, proxy: geometry), y: -10)
                    
                    
                    PageControl(index: self.index, count: self.count, color: self.pageControlColor)
                        .frame(width: nil, height: 10, alignment: .center)
                        .offset(x: getBlobStackOffset(proxy: geometry))
                        .padding(.vertical, 16)
                    
                    
                    Button(action: {
                        showAppleLogin()
                    }) {
                        HStack {
                            //Image("bookmark.fill")
                            Text("Login with Apple")
                        }
                        .customButton()
                    }.frame(width: 280, height: 40, alignment: .center)
                    //.padding(.bottom, 16)
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
                    
                    var newIndex = Int(finalPosition / (fullWidth / CGFloat(self.count) * 0.7 ))
                    
                    if self.dragOffset > 0 { //Scroll to left
                        newIndex = Int(finalPosition / (fullWidth / CGFloat(self.count) * 1.3 ))
                    }
                    
                    
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
                    
                    print(finalPosition, self.dragOffset, newIndex)
                })
            )
        }
        
        
    }
    

    func getItemOffset(pageIndex: Int, proxy: GeometryProxy) -> CGFloat {
        return (proxy.size.width * CGFloat(self.index) * -1) +  self.dragOffset
    }
    
    func getBlobXOffset(pageIndex: Int, proxy: GeometryProxy) -> CGFloat {
        return (proxy.size.width/3.0) + ((proxy.size.width * CGFloat(self.index - 1) * -1) +  self.dragOffset) * 0.1
    }
    
    func getBlobStackOffset(proxy: GeometryProxy) -> CGFloat {
        return -1 * proxy.size.width
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

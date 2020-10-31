import SwiftUI
import MagicSDK
import MagicExt_OAuth

struct OnboardingView: View {
    // MARK:- State
    @Binding var finished: Bool
    @State var index: Int = 0
    @State var count: Int = 3
    @State var position: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    @EnvironmentObject var appStateStore: AppStateStore
        
    // MARK:- Content
    var imageNames: [String] = ["onboarding-image-1", "onboarding-image-2", "onboarding-image-3"]
    var titles: [LocalizedStringKey] = ["onboarding-title-1", "onboarding-title-2", "onboarding-title-3"]
    var descriptions: [LocalizedStringKey] = ["onboarding-subtitle-1", "onboarding-subtitle-2", "onboarding-subtitle-3"]
    
    var blobStartColor: Color = Color.darkBlueColor
    var blobEndColor: Color = Color.lightBlueColor
    
    var pageControlColor: Color = Color.darkBlueColor
    
    var titleColor: Color = Color.darkBlueColor
    var detailColor: Color = Color.lightGrayColor
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    OnboardingView_Blob()
                        .fill(LinearGradient(gradient: Gradient(colors: [self.blobStartColor, self.blobEndColor]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: geometry.size.width, height: geometry.size.height/3.0, alignment: .center)
                        .offset(x: getBlobXOffset(pageIndex: self.index, proxy: geometry), y: -100)
                    Spacer()
                    OnboardingView_Blob()
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
                            VStack(alignment: .center, spacing: 0) {
                                Image(self.imageNames[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 280, maxHeight: 320, alignment: .center)
                                    .padding(.horizontal, 48)
                                    //.padding(.bottom, 16)
                                                                    
                                Text(self.titles[i])
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(self.titleColor)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                
                                Text(self.descriptions[i])
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(self.detailColor).opacity(0.4)
                                    .padding(.horizontal, 16)
                                                                
                            }.frame(width: geometry.size.width, height: nil, alignment: .center)
                            }
                    }.offset(x: getItemOffset(pageIndex: self.index, proxy: geometry), y: -32)
                    
                    
                    OnboardingView_PageControl(index: self.index, count: self.count, color: self.pageControlColor)
                        .frame(width: nil, height: 10, alignment: .center)
                        .offset(x: getBlobStackOffset(proxy: geometry), y: -32)
                        .padding(.bottom, 16)
                    
                    
                    Button(action: {
                        showAppleLogin()
                    }) {
                        HStack {
                            //Image("bookmark.fill")
                            Text("apple-sign-in-button-title")
                        }
                        .customButton()
                    }
                    .frame(width: 300, height: 44, alignment: .center)
                    .padding(.horizontal, 40)
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
            appStateStore.logIn()
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

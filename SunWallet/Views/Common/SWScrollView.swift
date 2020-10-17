import SwiftUI

struct SWScrollView<Content: View>: View {
    // MARK:- Properties
    let title: Text
    let subtitle: Text
    let content: Content
    let presentationMode: Binding<PresentationMode>?
    
    init(title: Text, subtitle: Text, presentationMode: Binding<PresentationMode>? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.presentationMode = presentationMode
        self.content = content()
    }
    
    // MARK:- States
    @State private var offset: CGFloat = 0
    
    // MARK:- Calculated Variables
    private var subtitleOpacity: Double { Double(1 - offset / 30) }
    private var subtitleWidth: CGFloat? { offset > 10 ? 0 : nil }
    private var navigationBarShadow: CGFloat { max(0, offset * 0.02) }
    
    // MARK:- Subviews
    private var navigationBarButtons: some View {
        HStack {
            presentationMode.map { self.backButton(presentationMode: $0) }
            Spacer()
        }
        .padding(.bottom, 16)
        .padding(.leading, 16)
    }
    private var navigationBar: some View {
        Rectangle()
            .fill(Color(UIColor.systemBackground))
            .frame(height: 64)
            .frame(maxWidth: .infinity)
            .shadow(radius: navigationBarShadow)
            .overlay(navigationBarButtons, alignment: .bottomLeading)
    }
    private var scrollView: some View {
        TrackableScrollView(
            .vertical,
            showIndicators: false,
            contentOffset: $offset,
            content: content.padding(.top, 130)
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                self.scrollView
                
                self.navigationBar
                
                TitleView(title: self.title, subTitle: self.subtitle, screenWidth: geometry.size.width, offset: self.$offset)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SWScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SWScrollView(title: Text("Title"), subtitle: Text("Hi everyone")) {
            Rectangle().fill(Color.red)
        }
    }
}

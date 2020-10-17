import SwiftUI

private let navigationTitleAnimationOffset: CGFloat = 100
private let hMargin: CGFloat = 16
private let topMargin: CGFloat = 64

struct TitleView: View {
    let title: Text
    let subTitle: Text
    let screenWidth: CGFloat
    @Binding var offset: CGFloat
    
    private var progress: CGFloat {
        let relativeOffset = offset / navigationTitleAnimationOffset
        return min(1, max(0, relativeOffset))
    }
    private var backwardProgress: CGFloat { 1 - progress }
    private var currentTitleFont: CGFloat { (36 - 18) * backwardProgress + 18 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            subTitle
                .foregroundColor(.blueGray)
                .opacity(Double(self.backwardProgress))
            
            title.minimumScaleFactor(0.01)
                .alignmentGuide(.leading) { d in
                    let fullOffset = self.screenWidth / 2 - hMargin - d[HorizontalAlignment.center]
                    return d[.leading] - fullOffset * self.progress
                }
                .offset(x: 0, y: -((topMargin - 16) * self.progress))
                .frame(height: self.currentTitleFont)
        }
        .padding(.horizontal, hMargin)
        .alignmentGuide(.top) { _ in -topMargin + (self.offset < 0 ? self.offset : 0) }
    }
}

struct TitleView_Previews: PreviewProvider {
    
    static var previews: some View {
        TitleView(
            title: Text("Hello ") + Text("Hello").foregroundColor(.red),
            subTitle: Text("Example"),
            screenWidth: 320,
            offset: .constant(0)
        )
    }
}

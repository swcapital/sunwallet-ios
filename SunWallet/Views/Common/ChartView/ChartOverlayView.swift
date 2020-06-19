import SwiftUI

struct ChartOverlayView: View {
    // MARK:- Properties
    let accentPoint: CGPoint
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.lightGray)
                    .position(x: geometry.size.width * self.accentPoint.x, y: geometry.size.height / 2)
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .shadow(radius: 5)
                    Circle()
                        .fill(self.color)
                        .frame(width: 10, height: 10)
                }
                .position(
                    x: geometry.size.width * self.accentPoint.x,
                    y: geometry.size.height * (1 - self.accentPoint.y)
                )
            }
        }
    }
}

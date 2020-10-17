import SwiftUI

extension View {
    
    func roundedBorder() -> some View {
        let border = RoundedRectangle(cornerRadius: 8)
            .stroke(Color.lightGray, lineWidth: 2)
        return self.overlay(border)
    }
}

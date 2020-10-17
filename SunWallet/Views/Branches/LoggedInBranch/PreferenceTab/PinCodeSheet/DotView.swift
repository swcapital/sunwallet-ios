import SwiftUI

struct DotView: View {
    // MARK:- Properties
    let active: Bool
    
    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: active ? 26 : 4)
            .frame(width: 26, height: 26)
            .cornerRadius(13)
    }
}

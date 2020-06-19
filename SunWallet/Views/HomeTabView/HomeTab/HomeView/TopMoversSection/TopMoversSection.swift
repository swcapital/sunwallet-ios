import SwiftUI

struct TopMoversSection: View {
    // MARK:- Properties
    let assets: [Asset]
    
    // MARK:- Subviews
    private var header: some View {
        Text("Top Movers")
            .font(.title)
            .padding(16)
    }
    
    var body: some View {
        Section(header: header) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(assets) { asset in
                        TopMoverCell(asset: asset)
                    }
                }
                .padding(.top, 10)
            }
            .frame(height: 160)
        }
    }
}

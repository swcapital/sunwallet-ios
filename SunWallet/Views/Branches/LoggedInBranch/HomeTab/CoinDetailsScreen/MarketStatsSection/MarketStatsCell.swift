import SwiftUI

struct MarketStatsCell: View {
    // MARK:- Properties
    let marketStat: MarketStat
    
    var body: some View {
        ExpandableCell(
            header: {
                HStack(spacing: 8) {
                    Image(marketStat.imageName)
                    Text(marketStat.title)
                        .font(.headline)
                    Spacer(minLength: 0)
                    marketStat.value
                        .lineLimit(1)
                }
            },
            content: {
                Text(marketStat.description)
                    .fixedSize(horizontal: false, vertical: true)
            }
        )
    }
}

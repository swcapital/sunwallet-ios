import SwiftUI

struct WatchListSection: View {
    // MARK:- Properties
    let assets: [Asset2]
    
    // MARK:- Subviews
    private var header: some View {
        Text("Watchlist")
            .font(.title)
            .padding(16)
    }
    
    var body: some View {
        Section(header: header) {
            Divider()
            ForEach(assets) { asset in
                NavigationLink(destination: CoinDetails(asset: asset)) {
                    HomeCurrencyCell(asset: asset)
                        .foregroundColor(.primary)
                }
                
            }
            .listStyle(GroupedListStyle())
        }
    }
}

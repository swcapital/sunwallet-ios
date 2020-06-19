import SwiftUI

struct HomeTabView: View {
    // MARK:- States
    @State private var showTradeSheet = false
    
    // MARK:- Subviews
    private var tradeButtonImage: some View {
        Image(systemName: "arrow.right.arrow.left")
            .foregroundColor(.white)
            .font(.headline)
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color.primaryBlue))
            .padding(5)
            .onTapGesture { withAnimation { self.showTradeSheet.toggle() } }
    }
    
    var body: some View {
        ZStack {
            TabView() {
                HomeView()
                    .tabItem({ makeTabLabel(imageName: "home", title: "Home") })
                    .tag(1)
                
                PortfolioView()
                    .tabItem({ makeTabLabel(imageName: "discover", title: "Portfolio") })
                    .tag(2)
                
                Spacer()
                    .tabItem({ Text(" ") })
                    .tag(3)
                
                HomeView()
                    .tabItem({ makeTabLabel(imageName: "invest", title: "Prices") })
                    .tag(4)
                
                PreferenceView()
                    .tabItem({ makeTabLabel(imageName: "settings", title: "Settings") })
                    .tag(5)
            }
            .overlay(tradeButtonImage, alignment: .bottom)
            
            if showTradeSheet {
                BottomSheetView(isOpen: $showTradeSheet) {
                    TradeSheet()
                }
            }
        }
    }
    
    // MARK:- Methods
    private func makeTabLabel(imageName: String, title: String) -> some View {
        HStack {
            Image(imageName)
            Text(title)
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
            .environmentObject(DataSource())
    }
}

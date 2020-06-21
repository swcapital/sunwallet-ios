import SwiftUI

struct HomeTabView: View {
    // MARK:- States
    @State private var showTradeSheet = false
    
    // MARK:- Subviews
    private var tradeButton: some View {
        Button(action: { self.showTradeSheet.toggle() }) {
            Image(systemName: "arrow.right.arrow.left")
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 60, height: 40)
                .background(Circle().fill(Color.primaryBlue))
                .padding(5)
        }
        .buttonStyle(ScalableButtonStyle())
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
                    .tabItem({ Text("") })
                    .disabled(true)
                    .tag(3)
                
                HomeView()
                    .tabItem({ makeTabLabel(imageName: "invest", title: "Prices") })
                    .tag(4)
                
                PreferenceView()
                    .tabItem({ makeTabLabel(imageName: "settings", title: "Settings") })
                    .tag(5)
            }
            .overlay(tradeButton, alignment: .bottom)
            
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

import SwiftUI
import BottomBar_SwiftUI

struct MainView: View {
    @EnvironmentObject var accountsStore: AccountsStore
    
    let items: [BottomBarItem] = [
        BottomBarItem(icon: Image("tab-bar-home"), title: "tab-bar-home", color: Color.lightBlueColor),
        BottomBarItem(icon: Image("tab-bar-search"), title: "tab-bar-search", color: Color.lightBlueColor),
        BottomBarItem(icon: Image("tab-bar-discover"), title: "tab-bar-discover", color: Color.lightBlueColor),
        BottomBarItem(icon: Image("tab-bar-settings"), title: "tab-bar-settings", color: Color.lightBlueColor)
    ]
    
    let itemViews = [AnyView(HomeScreen()), AnyView(PortfolioScreen()), AnyView(PortfolioScreen()), AnyView(PreferenceView())]
    
    @State private var selectedIndex: Int = 0

    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }
    
    // MARK:- States
    @State private var showTradeSheet = false
    @State private var actionView: AnyView?
    @State private var accounts: [Account] = []
    
    // MARK:- Subviews
    private var tradeButton: some View {
        Button(action: { self.showTradeSheet.toggle() }) {
            Image(systemName: "arrow.right.arrow.left")
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 60, height: 40)
                .background(Circle().fill(Color.primary))
                .padding(5)
        }
    }
    private var actionViewSheet: some View {
        actionView.map { actionView in
            actionView
                .edgesIgnoringSafeArea(.all)
                .zIndex(3)
                .transition(.move(edge: .bottom))
                .background(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(closeButton, alignment: .topTrailing)
        }
        .onPreferenceChange(ResultPreferenceKey.self) { result in
            guard result != nil else { return }
            self.actionView = nil
        }
    }
    private var actionButtonsSheet: some View {
        BottomSheetView(isOpen: $showTradeSheet) {
            TradeSheet(
                accounts: accounts,
                selectedView: .init(
                    get: { self.actionView },
                    set: { newValue in
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.showTradeSheet = false
                        }
                        withAnimation(Animation.easeOut(duration: 0.5).delay(0.5)) {
                            self.actionView = newValue
                        }
                    })
                )
        }
        .edgesIgnoringSafeArea(.all) // It should be in `BottomSheetView` but there is some bug in SwiftUI 1
    }
    private var closeButton: some View {
        Button(animationAction: { self.actionView = nil }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
        }
    }
    
    var body: some View {
        VStack {
            itemViews[selectedIndex]
            BottomBar(selectedIndex: $selectedIndex, items: items)
        }
        .onReceive(accountsStore.publisher, perform: { accounts in
            if let accounts = accounts {
                self.accounts = accounts
            }
        })
        /*
        ZStack {
            TabView() {
                HomeScreen()
                    .tabItem({ makeTabLabel(imageName: "home", title: "Home") })
                    .tag(1)
                
                PortfolioScreen()
                    .tabItem({ makeTabLabel(imageName: "discover", title: "Portfolio") })
                    .tag(2)
                
                Spacer()
                    .tabItem({ Text("") })
                    .disabled(true)
                    .tag(3)
                
                HomeScreen()
                    .tabItem({ makeTabLabel(imageName: "invest", title: "Prices") })
                    .tag(4)
                
                PreferenceView()
                    .tabItem({ makeTabLabel(imageName: "settings", title: "Settings") })
                    .tag(5)
            }
            .overlay(tradeButton, alignment: .bottom)
            
            actionViewSheet
            
            if showTradeSheet {
                actionButtonsSheet
            }
        }
 */
       
    }
    
    // MARK:- Methods
    private func makeTabLabel(imageName: String, title: String) -> some View {
        HStack {
            Image(imageName)
            Text(title)
        }
    }
}

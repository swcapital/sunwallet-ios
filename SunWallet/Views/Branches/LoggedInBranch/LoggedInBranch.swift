import SwiftUI

struct LoggedInBranch: View {
    @EnvironmentObject var accountsStore: AccountsStore
    
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
        .onReceive(accountsStore.publisher, perform: { accounts in
            if let accounts = accounts {
                self.accounts = accounts
            }
        })
    }
    
    // MARK:- Methods
    private func makeTabLabel(imageName: String, title: String) -> some View {
        HStack {
            Image(imageName)
            Text(title)
        }
    }
}

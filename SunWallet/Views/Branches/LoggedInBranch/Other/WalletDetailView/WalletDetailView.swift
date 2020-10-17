import SwiftUI

struct WalletDetailView: View {
    // MARK:- Properties
    let asset: Asset2
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK:- States
    @State var showReceiveAssetPopover = false
    
    // MARK:- Calculated Variables
    private var assets: [Asset2] {
        return dataSource.assets
    }
    
    // MARK:- Subviews
    private var qrButton: some View {
        Button(action: {
            self.showReceiveAssetPopover = true
        }, label: {
            Image("barcode")
        })
        .popover(isPresented: $showReceiveAssetPopover) {
            EmptyView()
            //ReceiveAssetScreen()
        }
    }
    private var sendButton: some View {
        Button(action: {
            
        }, label: {
            Image("send2")
        })
    }
    private var navigationBarButtons: some View {
        HStack(spacing: 12.0) {
            qrButton
            sendButton
        }
    }
    private var tradeButton: some View {
        Button(action: {}) {
            Text("Trade")
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding()
    }
    private var assetList: some View {
        List {
            Text("History")
                .font(.headline)
            ForEach(assets) { currency in
                WalletDetailCell(asset: currency)
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 32)
            
            Text(dataSource.user.assetBalance(asset).decimalString + " " + asset.title)
                .font(.title)
            Text(dataSource.user.dollarBalance(asset).dollarString)
                .foregroundColor(.blueGray)
            
            Spacer(minLength: 48)
            
            tradeButton
            
            assetList
        }
        .navigationBarTitle(Text(asset.title), displayMode: .inline)
        .navigationBarBackButton(presentationMode: self.presentationMode)
        .navigationBarItems(trailing: navigationBarButtons)
    }
}

struct WalletDetailView_Previews: PreviewProvider {
    static let dataSource = DataSource()
    
    static var previews: some View {
        NavigationView {
            WalletDetailView(asset: dataSource.user.balance.keys.randomElement()!)
                .environmentObject(dataSource)
        }
    }
}

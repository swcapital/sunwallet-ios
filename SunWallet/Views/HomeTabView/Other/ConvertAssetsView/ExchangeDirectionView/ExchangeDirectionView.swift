import SwiftUI

struct ExchangeDirectionView: View {
    // MARK:- Properties
    let onUserInput: () -> Void
    
    // MARK:- Bindings
    @Binding var exchange: AssetExchange
    
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var activeField: ExchangeFieldType = .source

    // MARK:- Calculated Variables
    private var assets: [Asset] {
        let excluded = activeField.isSource ? exchange.destination : exchange.source
        return dataSource.assets.filter { $0 != excluded }
    }
    
    // MARK:- Subviews
    private var assetList: some View {
        List {
            VStack(alignment: .leading) {
                Thumb()
                    .frame(maxWidth: .infinity)

                Text("Convert \(activeField.title)")
                    .font(.headline)
                    .padding(.vertical, 4)

                Divider()
            }

            ForEach(assets) { currency in
                ConvertAssetCell(
                    asset: currency,
                    action: { self.updateCurrentField(asset: currency) }
                )
            }
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            ExchangeFields(exchange: $exchange, activeField: $activeField)
                .padding()

            assetList
                .frame(height: 300)
                .cornerRadius(12)
        }
    }

    // MARK:- Methods
    private func updateCurrentField(asset: Asset) {
        switch activeField {
            case .source: self.exchange.source = asset
            case .destination: self.exchange.destination = asset
        }
        onUserInput()
    }
}

struct ExchangeDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeDirectionView(
            onUserInput: {},
            exchange: .constant(.init(source: TestData.randomAsset, destination: TestData.randomAsset))
        )
        .background(Color.black)
        .environmentObject(DataSource())
    }
}

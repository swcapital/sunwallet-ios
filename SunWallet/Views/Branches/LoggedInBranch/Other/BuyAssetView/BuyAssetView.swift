import SwiftUI

struct BuyAssetView: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var amountLabel = "0"
    @State private var assetExchange = AssetExchange(
        source: TestData.randomAsset,
        destination: TestData.randomAsset
    )

    // MARK:- Calculated Variables
    private var isPreviewButtonDisabled: Bool {
        assetExchange.value == 0
    }
    
    // MARK:- Subviews
    private var changeDirectionButton: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 24, weight: .ultraLight))
            Text(assetExchange.destination.code)
                .font(.footnote)
                .fontWeight(.light)
        }
        .foregroundColor(.blueGray)
        .padding(.horizontal)
        .onTapGesture {
            self.assetExchange.swap()
        }
    }
    private var amountView: some View {
        HStack(alignment: .center) {
            changeDirectionButton
                .opacity(0)
                .disabled(true)
            
            Text("\(self.amountLabel) \(assetExchange.source.code)")
                .font(.system(size: 56))
                .foregroundColor(Color.primaryBlue)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            changeDirectionButton
        }
        .frame(height: 80)
    }
    private var oneTimePurchaseButton: some View {
        Button(action: {}) {
            Image(systemName: "clock")
            Text("One time purchase")
        }
        .font(.headline)
        .foregroundColor(.primaryBlue)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Capsule().fill(Color(red: 243 / 255, green: 246 / 255, blue: 253 / 255)))
    }
    private var previewButton: some View {
        NavigationLink(destination: OrderPreviewView(assetExchange: assetExchange)) {
            Text("Preview Buy")
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isPreviewButtonDisabled)
        .padding(.vertical)
        .disabled(isPreviewButtonDisabled)
        .padding(.horizontal)
        
    }
    private var cardView: some View {
        HStack {
            Image("visa")
                .padding()
            VStack(alignment: .leading) {
                Text("Keb Hana Card Co.,Ltd.")
                    .lineLimit(1)
                    .font(.headline)
                Text("Limit: 10.000 $")
                    .font(.caption)
                    .foregroundColor(.blueGray)
            }
            Text("··· 0407")
                .font(.headline)
                .foregroundColor(.blueGray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer(minLength: 64)
                    amountView
                    
                    oneTimePurchaseButton
                }
                            
                Divider()
                
                cardView
                
                Divider()
                
                Keyboard(number: $assetExchange.value, label: $amountLabel)
                
                previewButton
            }
            .navigationBarTitle("Buy \(self.assetExchange.source.title)", displayMode: .inline)
        }
    }
}


struct BuyAssetView_Previews: PreviewProvider {
    static var previews: some View {
        BuyAssetView()
            .environmentObject(DataSource())
    }
}

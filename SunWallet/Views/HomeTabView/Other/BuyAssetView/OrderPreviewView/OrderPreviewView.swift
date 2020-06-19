import SwiftUI

struct OrderPreviewView: View {
    // MARK:- Properties
    let assetExchange: AssetExchange
    
    // MARK:- Environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK:- Calculated Variables
    private var amount: Double { assetExchange.source.dollarPrice * assetExchange.value }
    
    // MARK:- Subviews
    private var priceRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: Text("\(assetExchange.destination.code) Price"),
                subtitle: Text(assetExchange.destination.dollarPrice.dollarString)
            )
        }
    }
    private var tradeRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: Text("Trade on SunWallet"),
                subtitle: Text("Instantly")
            )
        }
    }
    private var withdrawRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: Text("Withdraw from SunWallet"),
                subtitle: Text("Instantly")
            )
        }
    }
    private var paymentRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: Text("Payment Method"),
                subtitle: HStack(alignment: .firstTextBaseline) {
                    Image("visa")
                    Text("Keb Hana Card Co.,Ltd.")
                        .multilineTextAlignment(.trailing)
                }
            )
        }
    }
    private var purchaseRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: Text("Purchase"),
                subtitle: Text(amount.dollarString)
            )
        }
    }
    private var feeRow: some View {
        VStack {
            Divider()
            OrderPreviewCell(
                title: HStack {
                    Text("Fee")
                    Button("?") {
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(Circle().fill(Color.gray))
                },
                subtitle: Text((amount * 0.05).dollarString)
            )
        }
    }
    private var buyButton: some View {
        Button("Buy now") {
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding(.vertical)
        .padding(.horizontal)
    }
    private var amountView: some View {
        Text("\(amount.currencyString) \(assetExchange.source.code)")
            .font(.largeTitle)
            .foregroundColor(Color.primaryBlue)
            .frame(maxWidth: .infinity)
            .lineLimit(1)
            .frame(height: 80)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                amountView
                VStack {
                    priceRow
                    tradeRow
                    withdrawRow
                    paymentRow
                    purchaseRow
                    feeRow
                    Divider()
                }
            }
            buyButton
        }
        .navigationBarBackButton(presentationMode: presentationMode)
        .navigationBarTitle("Order preview", displayMode: .inline)
    }
}

struct BuyAssetPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        OrderPreviewView(
            assetExchange: .init(source: TestData.randomAsset, destination: TestData.randomAsset)
        )
    }
}

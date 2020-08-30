import SwiftUI

struct TradeSheet: View {
    @Binding var selectedView: AnyView?

    var body: some View {
        VStack() {
            TradeSheetCell(
                imageName: "buy",
                title: "Buy",
                subtitle: "Buy crypto with cash"
            )
            
            Divider()
            
            TradeSheetCell(
                imageName: "sell",
                title: "Sell",
                subtitle: "Sell crypto with cash"
            )
            
            Divider()
            
            TradeSheetCell(
                imageName: "convert",
                title: "Convert",
                subtitle: "Convert one crypto to another"
            )
            
            Divider()
            
            TradeSheetCell(
                imageName: "send",
                title: "Send",
                subtitle: "Send crypto to another wallet"
            )
            
            Divider()
            
            TradeSheetCell(
                imageName: "receive",
                title: "Receive",
                subtitle: "Receive crypto from another wallet"
            )
            .onTapGesture {
                self.selectedView = AnyView(ReceiveAssetView())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

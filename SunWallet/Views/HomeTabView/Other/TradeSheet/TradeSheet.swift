import SwiftUI

struct TradeSheet: View {

    var body: some View {
        VStack() {
            TradeSheetCell(
                imageName: "buy",
                title: "Buy",
                subtitle: "Buy crypto with cash"
            )
            TradeSheetCell(
                imageName: "sell",
                title: "Sell",
                subtitle: "Sell crypto with cash"
            )
            TradeSheetCell(
                imageName: "convert",
                title: "Convert",
                subtitle: "Convert one crypto to another"
            )
            TradeSheetCell(
                imageName: "send",
                title: "Send",
                subtitle: "Send crypto to another wallet"
            )
            TradeSheetCell(
                imageName: "receive",
                title: "Receive",
                subtitle: "Receive crypto from another wallet"
            )
        }
        .frame(maxWidth: .infinity)
        
    }
}


struct TradeSheet_Previews: PreviewProvider {
    static var previews: some View {
        TradeSheet()
    }
}

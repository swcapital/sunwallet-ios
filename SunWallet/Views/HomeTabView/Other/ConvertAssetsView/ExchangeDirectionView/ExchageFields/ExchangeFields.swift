import SwiftUI

struct ExchangeFields: View {
    // MARK:- Bindings
    @Binding var exchange: AssetExchange
    @Binding var activeField: ExchangeFieldType
    
    // MARK:- Subviews
    private var reverseButton: some View {
        Button(action: onReverseDirection) {
            ZStack() {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.lightGray)

                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 0) {
                AssetField(
                    asset: exchange.source,
                    title: ExchangeFieldType.source.title,
                    active: activeField.isSource
                )
                .onTapGesture { self.activeField = .source }

                Divider()

                AssetField(
                    asset: exchange.destination,
                    title: ExchangeFieldType.destination.title,
                    active: activeField.isDestination
                )
                .onTapGesture { self.activeField = .destination }
            }
            reverseButton
        }
        .background(Color.white)
        .cornerRadius(12)
    }

    // MARK:- Methods
    private func onReverseDirection() {
        exchange.swap()
    }
}

struct ExchangeFields_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeFields(
            exchange: .constant(.init(source: TestData.randomAsset, destination: TestData.randomAsset)),
            activeField: .constant(.destination)
        )
    }
}

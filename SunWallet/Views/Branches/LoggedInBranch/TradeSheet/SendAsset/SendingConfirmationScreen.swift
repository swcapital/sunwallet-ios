import SwiftUI
import Combine

struct SendingConfirmationScreen: View {
    @EnvironmentObject var blockchainStore: BlockchainStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let account: Account
    let amount: Amount
    let destination: String
    
    @State private var error: String?
    @State private var cancellable: AnyCancellable?
    @State private var result: Bool?
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading) {
                Text("Send From:")
                    .font(.title)
                
                LabelField(text: account.wallet.address)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading) {
                Text("Send To:")
                    .font(.title)
                
                LabelField(text: destination)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading) {
                Text("Amount:")
                    .font(.title)
                
                HStack {
                    Text(amount.crypto.currencyString(code: account.asset.code.uppercased()))
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .padding()
                    
                    Divider()
                    
                    Text(amount.user.dollarString)
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                
                Divider()
            }
                
            Spacer()
            
            Button("Confirm", action: send)
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .showAlert(error: $error)
        .preference(key: ResultPreferenceKey.self, value: result)
    }
    
    private func send() {
        self.cancellable = blockchainStore.send(amount: amount.crypto, from: account, to: destination)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .finished:
                        self.result = true
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                },
                receiveValue: {}
            )
    }
}

private struct LabelField: View {
    let icon: Image = Image(systemName: "creditcard")
    let text: String
    
    var body: some View {
        HStack {
            icon
            
            Text(text)
                .lineLimit(1)
            
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct LabelField_Previews: PreviewProvider {
    static var previews: some View {
        LabelField(text: "Hello, World!")
    }
}

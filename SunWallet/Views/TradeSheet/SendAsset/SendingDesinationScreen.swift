import SwiftUI

struct SendingDesinationScreen: View {
    let account: Account
    let amount: Amount
    
    @State private var address: String = ""
    @State private var showCameraView = false
    
    private var addressProxy: Binding<String?> {
        .init(
            get: { address },
            set: { if let x = $0 { address = x } }
        )
    }
    
    private var qrButton: some View {
        Button(action: { self.showCameraView = true }) {
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Enter address", text: $address)
                .padding()
                .padding(.trailing, 32)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
                .overlay(qrButton.padding(.trailing, 12), alignment: .trailing)
            
            Spacer()
            
            NavigationLink(
                "Next",
                destination: SendingConfirmationScreen(
                    account: account,
                    amount: amount,
                    destination: address
                )
            )
            .buttonStyle(PrimaryButtonStyle())
            .disabled(address.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationBarTitle("Send to")
        .popover(isPresented: $showCameraView) { ScanAddressScreen(address: addressProxy) }
    }
}

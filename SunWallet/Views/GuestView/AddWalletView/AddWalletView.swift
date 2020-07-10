import SwiftUI

struct AddWalletView: View {
    let completion: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                ImportWalletView(completion: completion)
                
                ORView()
                
                NavigationLink(destination: CreateWalletView(completion: completion)) {
                    Text("Create New")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity)
            .navigationBarTitle("Add wallet")
        }
    }
}

struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletView(completion: {})
    }
}

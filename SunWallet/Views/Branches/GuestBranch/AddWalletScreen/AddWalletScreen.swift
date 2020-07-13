import SwiftUI

struct AddWalletScreen: View {
    let completion: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                ImportWalletView(completion: completion)
                
                ORView()
                
                NavigationLink(destination: CreateWalletScreen(completion: completion)) {
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
        AddWalletScreen(completion: {})
    }
}

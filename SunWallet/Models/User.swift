import Foundation

class User: ObservableObject {
    var email: String
    var ownerAddress: String
    var wallet: Wallet
        
    init(email: String, ownerAddress: String, wallet: Wallet) {
        self.email = email
        self.ownerAddress = ownerAddress
        self.wallet = wallet
    }
}

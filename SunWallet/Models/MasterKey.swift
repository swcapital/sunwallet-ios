import Foundation

struct MasterKey: Codable {
    let id: UUID
    let mnemonic: String
    let title: String
    let currencies: [WalletCurrency]
    
    init(mnemonic: String, currencies: [WalletCurrency]) {
        self.id = UUID()
        self.mnemonic = mnemonic
        self.title = "Created at: \(Date())"
        self.currencies = currencies
    }
}

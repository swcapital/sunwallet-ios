import Foundation

struct MasterKeyInfo: Codable {
    let id: UUID
    let title: String
    let currencies: [WalletCurrency]
}

extension MasterKeyInfo: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

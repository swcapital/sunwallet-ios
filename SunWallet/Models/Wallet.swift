import Foundation

struct Wallet: Codable  {
    let address: String
    let title: String
    let asset: Asset
    let masterKeyID: UUID
}

extension Wallet: Hashable, Identifiable {
    var id: String { address }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

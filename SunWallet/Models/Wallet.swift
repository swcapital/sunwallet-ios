import Foundation

struct Wallet: Codable  {
    let address: String
    let asset: Asset
    let masterKeyID: UUID
}

extension Wallet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

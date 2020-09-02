import Foundation

struct Wallet: Codable  {
    let address: String
    let title: String
    let asset: Asset
    let masterKeyID: UUID
}

extension Wallet: Identifiable {
    var id: String { address }
}

extension Wallet: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
    }
}

extension Wallet: Comparable {
    
    static func < (lhs: Wallet, rhs: Wallet) -> Bool {
        lhs.asset < rhs.asset
    }
}

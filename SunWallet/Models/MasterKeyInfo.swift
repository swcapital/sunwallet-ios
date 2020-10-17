import Foundation

struct MasterKeyInfo: Codable {
    let id: UUID
    let title: String
    let assets: [Asset]
}

extension MasterKeyInfo: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

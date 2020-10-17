import Foundation

struct UTXO: Codable {
    let txid: String
    let amount: Double
    let vout: Int
}

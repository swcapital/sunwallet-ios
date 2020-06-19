import Foundation

struct Asset: Identifiable {
    let id = UUID()

    let title: String
    let code: String
    let imageName: String
    
    var about: String {
        """
        \(title) is a cryptocurrency. It is a decentralized digital currency without a central bank or single administrator that can be sent from user to user on the peer-to-peer bitcoin network without the need for intermediaries. Transactions are verified by network nodes through cryptography and recorded in a public distributed ledger called a blockchain.
        """
    }
    var website: URL { URL(string: "https://bitcoin.org/")! }
    var whitePaper: URL { URL(string: "https://bitcoin.org/bitcoin.pdf")! }

    let valueHistory = ValueHistory()
    var dollarPrice: Double { valueHistory.hourly.last! }
    var dollarPriceChange: Double { valueHistory.hourly.last! - valueHistory.hourly.dropLast().last! }
    
    let marketCap: Double = Double.random(in: 1_000_000 ..< 1_000_000_000_000_000)
    let volume: Double = Double.random(in: 1_000 ..< 1_000_000_000_000_000)
    let circulatingSupply: Double = Double.random(in: 1_000 ..< 1_000_000_000_000_000)
    let allTimeHigh: Double = Double.random(in: 1_000 ..< 10_000)
    let tradingActivity: Double = Double.random(in: 0 ..< 1)
    let medianDaysHeld: Int = Int.random(in: 1 ..< 100)
    let popularity: Int = Int.random(in: 1 ..< 200)
}

extension Asset: Hashable {
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension Asset: Equatable {
    
    static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.id == rhs.id
    }
}

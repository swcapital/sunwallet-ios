import Foundation

struct Asset: Codable {
    let id: String
    let symbol: String
    let address: String
    let supportsMoonpay: Bool
    let excludedCountries: Array<String>
    let categories: Array<String>
    let lists: Array<String>
    let circulatingSupply: Float
    let totalSupply: Float
    let maxSupply: Float
    let video: String
    let website: String
    let blog: String
    let whitepaper: String
    let twitter: String
    let telegram: String
    let reddit: String
    let github: String
    let names: Dictionary<String, String>
    
    let valueHistory = ValueHistory()
    var dollarPrice: Double { valueHistory.hourly.last! }
    var dollarPriceChange: Double { valueHistory.hourly.last! - valueHistory.hourly.dropLast().last! }

    let marketCap: Double = valueHistory.hourly.last! * circulatingSupply
    let fullyDilutedMarketCap: Double = valueHistory.hourly.last! * maxSupply
    
    let tradingVolume: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.symbol = try container.decode(String.self).lowercased()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
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

extension Account: Equatable {
    
    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.wallet.address == rhs.wallet.address && lhs.asset == rhs.asset && lhs.amount == rhs.amount
    }
}

import Foundation

struct Asset: Codable {
    let code: String
    
    var title: String {
        switch code {
        case "atom": return "Cosmos"
        case "bat": return "Basic Attention Token"
        case "bch": return "Bitcoin Cash"
        case "bnb": return "Binance Coin"
        case "bnt": return "Bancor"
        case "btc": return "Bitcoin"
        case "cny": return "eToro Chinese Yuan"
            
        case "eth": return "Etherium"
        case "eur": return "Euro"
        case "gbp": return "Pound Sterling"
        case "jpy": return "Japanese Yen"
        case "kcs": return "KuCoin Shares"
            
        case "knc": return "Kyber Network"
        case "matic": return "Matic Network"
        case "nexo": return "Nexo"
        case "omg": return "OmiseGO"
            
        case "usd": return "US Dollar"
            
        default: return code.uppercased()
        }
    }
    
    var imageName: String { code }
    
    init(_ code: String) {
        self.code = code.lowercased()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.code = try container.decode(String.self).lowercased()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(code)
    }
}

extension Asset {
    static let ampl = Asset("ampl")
    static let bal = Asset("bal")
    static let band = Asset("band")
    static let bat = Asset("bat")
    static let bnb = Asset("bnb")
    static let bnt = Asset("bnt")
    static let btc = Asset("btc")
    static let busd = Asset("busd")
    static let comp = Asset("comp")
    static let cusdc = Asset("cusdc")
    static let cusdt = Asset("cusdt")
    static let dai = Asset("dai")
    static let eth = Asset("eth")
    static let ftt = Asset("ftt")
    static let ht = Asset("ht")
    static let knc = Asset("knc")
    static let lend = Asset("lend")
    static let leo = Asset("leo")
    static let link = Asset("link")
    static let lrc = Asset("lrc")
    static let mana = Asset("mana")
    static let matic = Asset("matic")
    static let okb = Asset("okb")
    static let pax = Asset("pax")
    static let paxg = Asset("paxg")
    static let rep = Asset("rep")
    static let snx = Asset("snx")
    static let tusd = Asset("tusd")
    //static let usd = Asset("usd")
    static let usdc = Asset("usdc")
    static let usdt = Asset("usdt")
    static let xaut = Asset("xaut")
    static let zrx = Asset("zrx")
    
    static let coins: [Asset] = [.btc, .eth]
    static let etherTokens: [Asset] = [
        .ampl, .bal, .band, .bat, .bnb, .bnt, .busd,
        .comp, .cusdc, .cusdt, .dai, .ftt, .ht, .knc,
        .lend, .leo, .link, .lrc, .mana, .matic, .okb,
        .pax, .paxg, .rep, .snx, .tusd, .usdc, .usdt, .xaut, .zrx
    ]
}

extension Asset: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

extension Asset: Equatable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.code == rhs.code
    }
}

extension Asset: Comparable {
    
    static func < (lhs: Asset, rhs: Asset) -> Bool {
        switch (lhs, rhs) {
        case (.btc, _): return true
        case (_, .btc): return false
        case (.eth, _): return true
        case (_, .eth): return false
        default: return lhs.code < rhs.code
        }
    }
}

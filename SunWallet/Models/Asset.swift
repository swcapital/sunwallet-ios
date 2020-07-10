import Foundation

struct Asset: Codable, Identifiable {
    let id = UUID()
    
    let code: String
    let title: String
    let imageName: String?
    
    init(code: String, title: String? = nil, imageName: String? = nil) {
        self.code = code
        self.title = title ?? code
        self.imageName = imageName
    }
}

extension Asset {
    static let usd = Asset(code: "USD", title: "US Dollar")
    static let bitcoin = Asset(code: "BTC", title: "Bitcoin", imageName: "btc")
    static let cosmos = Asset(code: "ATOM", title: "Cosmos", imageName: "atom")
    static let bat = Asset(code: "BAT", title: "Basic Attention Token", imageName: "bat")
    static let bitcoinCash = Asset(code: "BCH", title: "Bitcoin Cash", imageName: "btc")
    static let etherium = Asset(code: "ETH", title: "Etherium", imageName: "eth")
    static let binanceCoin = Asset(code: "BNB", title: "Binance Coin", imageName: "bnb")
    static let bancor = Asset(code: "BNT", title: "Bancor", imageName: "bnt")
    static let cny = Asset(code: "CNY", title: "eToro Chinese Yuan", imageName: "cny")
    static let euro = Asset(code: "EUR", title: "Euro", imageName: "eur")
    static let pound = Asset(code: "GBP", title: "Pound Sterling", imageName: "gbp")
    static let yen = Asset(code: "JPY", title: "Japanese Yen", imageName: "jpy")
    static let kcs = Asset(code: "KCS", title: "KuCoin Shares", imageName: "kcs")
    static let knc = Asset(code: "KNC", title: "Kyber Network", imageName: "knc")
    static let matic = Asset(code: "MATIC", title: "Matic Network", imageName: "matic")
    static let nexo = Asset(code: "NEXO", title: "Nexo", imageName: "nexo")
    static let omg = Asset(code: "OMG", title: "OmiseGO", imageName: "omg")
}

extension Asset: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

import UIKit

class DataSource: ObservableObject {
    let assets: [Asset2] = [
        .init(title: "Bitcoin", code: "BTC", imageName: "btc"),
        .init(title: "Cosmos", code: "ATOM", imageName: "atom"),
        .init(title: "Basic Attention Token", code: "BAT", imageName: "bat"),
        .init(title: "Bitcoin Cash", code: "BCH", imageName: "btc"),
        .init(title: "Ethereum", code: "ETH", imageName: "eth"),
        .init(title: "Binance Coin", code: "BNB", imageName: "bnb"),
        .init(title: "Bancor", code: "BNT", imageName: "bnt"),
        .init(title: "eToro Chinese Yuan", code: "CNY", imageName: "cny"),
        .init(title: "Euro", code: "EUR", imageName: "eur"),
        .init(title: "Pound Sterling", code: "GBP", imageName: "gbp"),
        .init(title: "Japanese Yen", code: "JPY", imageName: "jpy"),
        .init(title: "KuCoin Shares", code: "KCS", imageName: "kcs"),
        .init(title: "Kyber Network", code: "KNC", imageName: "knc"),
        .init(title: "Matic Network", code: "MATIC", imageName: "matic"),
        .init(title: "Nexo", code: "NEXO", imageName: "nexo"),
        .init(title: "OmiseGO", code: "OMG", imageName: "omg"),
    ]
    
    let articles: [Article] = [
        .init(
            title: "ETH is in Focus Ahead of Ethereum 2.0: What to Expect?",
            text: "The cryptocurrency market might have had a horrid time over the past few weeks, but things have changed this week. Much of the reversal in fortunes is possibly tied to the upcoming Bitcoin halvening event.",
            imageName: "referrals",
            source: "Bloomberg",
            date: "Apr 23",
            tag: "Bitcoin"
        ),
        .init(
            title: "ETH is in Focus Ahead of Ethereum 2.0: What to Expect?",
            text: "The cryptocurrency market might have had a horrid time over the past few weeks, but things have changed this week. Much of the reversal in fortunes is possibly tied to the upcoming Bitcoin halvening event.",
            imageName: "referrals",
            source: "Bloomberg",
            date: "Apr 23",
            tag: nil
        ),
        .init(
            title: "ETH is in Focus Ahead of Ethereum 2.0: What to Expect?",
            text: "The cryptocurrency market might have had a horrid time over the past few weeks, but things have changed this week. Much of the reversal in fortunes is possibly tied to the upcoming Bitcoin halvening event.",
            imageName: nil,
            source: "Bloomberg",
            date: "Apr 23",
            tag: nil
        ),
    ]
    
    lazy var topMovers: [Asset2] = Array(assets.random(5))
        
    lazy var user = User(
        favorites: Array(assets.random(6)),
        balance: Dictionary(uniqueKeysWithValues: assets.map { ($0, Double.random(in: 0 ..< 20)) })
    )
}


extension Collection {
    func random(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

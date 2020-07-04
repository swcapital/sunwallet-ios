import Foundation

struct CurrencyStore {
    static var currentCode: String { Locale.current.currencyCode ?? "USD" }
    static var currentSymbol: String { Locale.current.currencySymbol ?? "$" }
}

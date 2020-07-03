import Foundation

struct CurrencyStore {
    static var currentCode: String { Locale.current.currencyCode ?? "USD" }
}

import Foundation

extension NumberFormatter {

    static var currency: NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.locale = Locale.current
        return currencyFormatter
    }
}

import Foundation

extension Double {
    var isPositive: Bool { self >= 0 }

    var decimalString: String {
        let formatter = NumberFormatter.currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber)!
    }
    
    func currencyString(code: String) -> String {
        let formatter = NumberFormatter.currency
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = code
        return formatter.string(from: self as NSNumber)!
    }
    
    var dollarString: String {
        "$\(decimalString)"
    }
    
    var priceChangeString: String {
        let value = self * 100
        let prefix = (value > 0) ? "+" : ""
        return prefix + value.decimalString + " %"
    }
    
    var percentString: String {
        .init(format: "%.0f%%", self * 100)
    }
    
    var largeNumberString: String {
        let format = "%.1f %@"
        
        
        let tr = self / 1_000_000_000_000
        if tr > 1 {
            return String(format: format, tr, "Trillion")
        }
        
        let bl = self / 1_000_000_000
        if bl > 1 {
            return String(format: format, bl, "Billion")
        }
        
        let ml = self / 1_000_000
        if ml > 1 {
            return String(format: format, ml, "Million")
        }
        
        let th = self / 1_000
        if th > 1 {
            return String(format: format, th, "Thousand")
        }
        
        return String(format: format, self, "")
    }
}

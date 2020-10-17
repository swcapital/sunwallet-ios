import Foundation

struct KeyboardNumber {
    private var decimalDigits: [Int] = []
    private var fractionalDigits: [Int] = []
    private var hasFractionalPart: Bool = false

    private var decimalPart: Int { decimalDigits.digitsToInt() }
    private var fractionalPart: Int { fractionalDigits.digitsToInt() }

    var stringValue: String {
        var string = decimalDigits.map { $0.description }.joined()
        if string.count == 0 {
            string = "0"
        }
        if hasFractionalPart {
            string.append(Locale.current.decimalSeparator ?? ".")
            if fractionalDigits.count > 0 {
                string += fractionalDigits.map { $0.description }.joined()
            }
        }
        return string
    }

    var doubleValue: Double {
        get {
            let decimalPart = decimalDigits.digitsToInt()
            let fractionalPart = fractionalDigits.digitsToInt()
            return Double(decimalPart) + Double(fractionalPart) / pow(10, Double(fractionalDigits.count))
        }
        set {
            set(value: newValue)
        }
    }
    
    init(value: Double = 0) {
        set(value: value)
    }

    mutating func append(digit: Int) {
        if hasFractionalPart {
            fractionalDigits.append(digit)
        } else {
            guard !(decimalDigits.isEmpty && digit == 0) else { return }
            decimalDigits.append(digit)
        }
    }

    mutating func removeLast() {
        if hasFractionalPart {
            if fractionalDigits.isEmpty {
                hasFractionalPart = false
            } else {
                fractionalDigits.removeLast()
            }
        } else if !decimalDigits.isEmpty {
            decimalDigits.removeLast()
        }
    }

    mutating func setFractional() {
        guard !hasFractionalPart else { return }
        hasFractionalPart = true
    }
    
    mutating func reset() {
        hasFractionalPart = false
        decimalDigits = []
        fractionalDigits = []
    }
    
    mutating func set(value: Double) {
        reset()
        guard value != 0 else { return }
        
        let string = String(format: "%g", value)
        for c in string {
            if c == "." {
                setFractional()
            } else if let digit = Int(String(c)) {
                if hasFractionalPart {
                    fractionalDigits.append(digit)
                } else {
                    decimalDigits.append(digit)
                }
            }
        }
    }
}

private extension Array where Element == Int {

    func digitsToInt() -> Int {
        reduce(0) { result, element in
            result * 10 + element
        }
    }
}

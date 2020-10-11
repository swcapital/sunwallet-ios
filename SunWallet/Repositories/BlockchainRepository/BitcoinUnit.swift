import Foundation

class BitcoinUnit: Dimension {
    static let bitcoin = BitcoinUnit(symbol: "BTC", converter: UnitConverterLinear(coefficient: 1))
    static let satoshi = BitcoinUnit(symbol: "Satoshi", converter: UnitConverterLinear(coefficient: 1 / 100000000))
    
    override class func baseUnit() -> Self {
        bitcoin as! Self
    }
}

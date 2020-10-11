import Foundation

class EtheriumUnit: Dimension {
    static let etherium = EtheriumUnit(symbol: "ETH", converter: UnitConverterLinear(coefficient: 1.0))
    static let wei = EtheriumUnit(symbol: "Wei", converter: UnitConverterLinear(coefficient: 1 / 1000000000000000000))
    static let gwei = EtheriumUnit(symbol: "Wei", converter: UnitConverterLinear(coefficient: 1 / 1000000000))
    
    override class func baseUnit() -> Self {
        etherium as! Self
    }
}

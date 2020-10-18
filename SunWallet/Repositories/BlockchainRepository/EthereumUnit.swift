import Foundation

class EthereumUnit: Dimension {
    static let ethereum = EthereumUnit(symbol: "ETH", converter: UnitConverterLinear(coefficient: 1.0))
    static let wei = EthereumUnit(symbol: "Wei", converter: UnitConverterLinear(coefficient: 1 / 1000000000000000000))
    static let gwei = EthereumUnit(symbol: "Wei", converter: UnitConverterLinear(coefficient: 1 / 1000000000))
    
    override class func baseUnit() -> Self {
        ethereum as! Self
    }
}

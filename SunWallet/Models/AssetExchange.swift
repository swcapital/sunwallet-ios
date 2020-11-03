struct AssetExchange {
    var source: Asset
    var destination: Asset
    var value: Double = 0
    
    mutating func swap() {
        let temp = source
        source = destination
        destination = temp
    }
}

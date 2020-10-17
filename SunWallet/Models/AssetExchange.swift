struct AssetExchange {
    var source: Asset2
    var destination: Asset2
    var value: Double = 0
    
    mutating func swap() {
        let temp = source
        source = destination
        destination = temp
    }
}

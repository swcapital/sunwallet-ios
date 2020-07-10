enum WalletCurrency: String, Codable, CaseIterable, Hashable {
    case btc
    case eth
    
    var asset: Asset {
        switch self {
        case .btc: return .bitcoin
        case .eth: return .etherium
        }
    }
}

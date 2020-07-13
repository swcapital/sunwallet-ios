enum WalletCurrency: String, Codable, CaseIterable, Hashable {
    case btc
    case eth
    
    var asset: Asset {
        switch self {
        case .btc: return .btc
        case .eth: return .eth
        }
    }
}

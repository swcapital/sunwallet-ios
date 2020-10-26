enum ExchangeFieldType {
    case source
    case destination

    var isSource: Bool { self == .source }
    var isDestination: Bool { self == .destination }

    var title: String {
        switch self {
            case .source: return "From"
            case .destination: return "To"
        }
    }
}

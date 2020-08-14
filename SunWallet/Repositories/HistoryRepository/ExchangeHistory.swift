import Foundation

struct ExchangeHistory: Codable {
    private let id = UUID()
    
    let source: Asset
    let destination: Asset
    let historySet: HistorySet
}

extension ExchangeHistory: Equatable {
    
    static func == (lhs: ExchangeHistory, rhs: ExchangeHistory) -> Bool {
        lhs.id == rhs.id
    }
}

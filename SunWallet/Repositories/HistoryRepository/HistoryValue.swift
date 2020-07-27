import Foundation

struct HistoryValue: Codable {
    let date: Date
    let value: Double
}

extension Array where Element == HistoryValue {
    
    func onlyValues() -> [Double] {
        map(\.value)
    }
}

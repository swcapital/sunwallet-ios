import Foundation

struct HistoryValue: Codable {
    let date: Date
    let value: Double
}

extension Array where Element == HistoryValue {
    
    func onlyValues() -> [Double] {
        map(\.value)
    }
    
    func growth() -> Double {
        guard let last = last?.value, let first = first?.value, first != last else { return 0 }
        return (last - first) / first
    }
}

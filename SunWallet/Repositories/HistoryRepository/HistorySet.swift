import Foundation

struct HistorySet: Codable {
    let hourly: [HistoryValue]
    let daily: [HistoryValue]
    let weekly: [HistoryValue]
    let monthly: [HistoryValue]
    var yearly: [HistoryValue]
    let all: [HistoryValue]
    
    var lastValue: Double { hourly.last?.value ?? 0 }
    var lastValueDiff: Double { ( (daily.last?.value ?? 0) / (daily.dropLast().last?.value ?? 0)) - 1 }
}

extension HistorySet {
    static func +(lhs: Self, rhs: Self) -> Self {
        .init(
            hourly: lhs.hourly ++ rhs.hourly,
            daily: lhs.daily ++ rhs.daily,
            weekly: lhs.weekly ++ rhs.weekly,
            monthly: lhs.monthly ++ rhs.monthly,
            yearly: lhs.yearly ++ rhs.yearly,
            all: lhs.all ++ rhs.all
        )
    }
}

infix operator ++
extension Array where Element == HistoryValue {

    static func ++(lhs: Self, rhs: Self) -> Self {
        zip(lhs, rhs).map { HistoryValue(date: $0.0.date, value: $0.0.value + $0.1.value) }
    }
}

import Foundation

struct ValueHistory {
    let all: [Double]
    let yearly: [Double]
    let monthly: [Double]
    let weekly: [Double]
    let daily: [Double]
    let hourly: [Double]
    
    init() {
        let initial = Double.random(in: 0..<1000)
        let change = Double.random(in: 1 ..< 20)
        let changeRange = -change ..< change
        let initials: [Double] = .init(initial: initial, range: 0..<100, count: 6)
        
        self.all = .init(initial: initials[0], range: changeRange, count: 365)
        self.yearly = .init(initial: initials[1], range: changeRange, count: 365)
        self.monthly = .init(initial: initials[2], range: changeRange, count: 365)
        self.weekly = .init(initial: initials[3], range: changeRange, count: 365)
        self.daily = .init(initial: initials[4], range: changeRange, count: 365)
        self.hourly = .init(initial: initials[5], range: changeRange, count: 365)
    }
}

extension Array where Element == Double {
    
    init(initial: Double, range: Range<Double>, count: Int) {
        var result = [initial]
        for _ in 0..<count {
            let next = result.last! + Double.random(in: range)
            result.append(next)
        }
        self = result
    }
}

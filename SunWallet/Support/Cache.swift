import Foundation

struct Cache<T> {
    private var entries: [String: CacheEntry<T>] = [:]
    
    mutating func set(_ value: T, atKey key: String, validUntil date: Date) {
        let item = CacheEntry(untilDate: date, item: value)
        entries[key] = item
    }
    
    func get(atKey key: String) -> T? {
        guard let entry = entries[key], entry.isValid else { return nil }
        return entry.item
    }
}

private struct CacheEntry<T> {
    let untilDate: Date
    let item: T
    
    var isValid: Bool {
        return Date() < untilDate
    }
}

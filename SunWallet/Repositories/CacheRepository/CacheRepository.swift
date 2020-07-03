import Foundation

protocol CacheRepository {
    func save<Value: Encodable>(_ value: Value, atKey key: String)
}

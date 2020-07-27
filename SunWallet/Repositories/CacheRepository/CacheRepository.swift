import Foundation

protocol CacheRepository {
    func save<Value: Encodable>(_ value: Value, atKey key: CacheKey)
    func load<Value: Decodable>(atKey key: CacheKey) -> Value?
}

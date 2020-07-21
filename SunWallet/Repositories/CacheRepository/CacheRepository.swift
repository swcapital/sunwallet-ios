import Foundation

protocol CacheRepository {
    func save<Value: Encodable>(_ value: Value, atKey key: CacheKey) -> Bool
    func load<Value: Decodable>(atKey key: CacheKey) -> Value?
}

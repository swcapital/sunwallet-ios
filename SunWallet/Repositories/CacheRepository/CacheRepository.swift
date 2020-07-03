import Foundation

protocol CacheRepository {
    func save<Value: Encodable>(_ value: Value, atKey key: String)
    func load<Value: Decodable>(atKey key: String) -> Value?
}

import Foundation

protocol KeyValueStorage {
    @discardableResult
    func save<Value: Encodable>(_ value: Value, atKey key: String) -> Bool
    func load<Value: Decodable>(atKey key: String) -> Value?
}

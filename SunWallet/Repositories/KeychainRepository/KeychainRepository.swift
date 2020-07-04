import Foundation
import Security

struct KeychainRepository: KeyValueStorage {
    
    @discardableResult
    func save<Value: Encodable>(_ value: Value, atKey key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(value) else { return false }
        return save(data, atKey: key)
    }
    
    func load<Value: Decodable>(atKey key: String) -> Value? {
        guard let data = load(key: key) else { return nil }
        return try? JSONDecoder().decode(Value.self, from: data)
    }

    private func save(data: Data, atKey key: String) -> Bool {
        let query: [CFString : Any] = [
            kSecClass: kSecClassGenericPassword as String,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }

    private func load(key: String) -> Data? {
        let query: [CFString : Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject? = nil
        guard SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr else {
            return nil
        }
        return dataTypeRef as! Data?
    }
}

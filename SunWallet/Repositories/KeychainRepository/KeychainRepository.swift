import Foundation
import Security

private let keyType = kSecClassGenericPassword

struct KeychainRepository {
    
    func saveValue<Value: Encodable>(_ value: Value, atKey key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(value) else { return false }
        return saveData(data, atKey: key)
    }
    
    func loadValue<Value: Decodable>(atKey key: String, accessHint: String) -> Value? {
        guard let data = loadData(atKey: key, accessHint: accessHint) else { return nil }
        return try? JSONDecoder().decode(Value.self, from: data)
    }

    func saveData(_ data: Data, atKey key: String) -> Bool {
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .userPresence,
            nil
        )
        
        let query: [CFString : Any] = [
            kSecClass: keyType,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessControl: accessControl!,
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let result = SecItemAdd(query as CFDictionary, nil)
        SecCopyErrorMessageString(result, nil).map { print($0) }

        return result == noErr
    }

    func loadData(atKey key: String, accessHint: String) -> Data? {
        let query: [CFString : Any] = [
            kSecClass: keyType,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecUseOperationPrompt: accessHint
        ]

        var data: AnyObject?
        let result = SecItemCopyMatching(query as CFDictionary, &data)
        guard result == noErr else { return nil }
        
        return data as! Data?
    }
}

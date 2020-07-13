import Foundation

struct CacheRepository {
    
    @discardableResult
    func save<Value: Encodable>(_ value: Value, atKey key: CacheKey) -> Bool  {
        guard let url = fileURL(forKey: key.value), let data = try? JSONEncoder().encode(value) else {
            return false
        }
        return (try? data.write(to: url)) != nil
    }
    
    func load<Value: Decodable>(atKey key: CacheKey) -> Value? {
        guard let url = fileURL(forKey: key.value), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(Value.self, from: data)
    }
    
    private func fileURL(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        return cacheDirectory?.appendingPathComponent(key)
    }
}

struct CacheKey {
    let value: String
}

import Foundation

struct RealCacheRepository: CacheRepository {
    
    func save<Value>(_ value: Value, atKey key: String) where Value : Encodable {
        guard let url = fileURL(forKey: key), let data = try? JSONEncoder().encode(value) else {
            return
        }
        try? data.write(to: url)
    }
    
    func load<Value>(atKey key: String) -> Value? where Value : Decodable {
        guard let url = fileURL(forKey: key), let data = try? Data(contentsOf: url) else {
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

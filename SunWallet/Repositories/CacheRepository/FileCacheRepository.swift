import Foundation

struct FileCacheRepository: CacheRepository {
    
    func save<Value: Encodable>(_ value: Value, atKey key: CacheKey)  {
        guard let url = fileURL(forKey: key), let data = try? JSONEncoder().encode(value) else {
            return
        }
        try? data.write(to: url)
    }
    
    func load<Value: Decodable>(atKey key: CacheKey) -> Value? {
        guard let url = fileURL(forKey: key), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode(Value.self, from: data)
    }
    
    private func fileURL(forKey key: CacheKey) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        return cacheDirectory?.appendingPathComponent(key.value)
    }
}

private extension CacheKey {
    static let timeRepository = CacheKey(value: "._timeRepository")
}

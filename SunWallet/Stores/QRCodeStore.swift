import Combine
import Foundation
import SwiftUI

struct QRCodeStore {
    private let cacheRepository: CacheRepository = FileCacheRepository()
    
    func generateImage(for address: String) -> Image {
        let data: Data
        if let cacheData = imageCache(address: address) {
            data = cacheData
        } else {
            guard let imageData = makeImageData(address: address) else {
                fatalError("Something went wrong")
            }
            data = imageData
            addCache(data, for: address)
        }
        
        let uiImage = UIImage(data: data)!
        return Image(uiImage: uiImage)
    }
}

private extension QRCodeStore {
    
    private func image(from string: String) -> CIImage? {
        guard let data = string.data(using: String.Encoding.utf8) else { return nil }
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        let transform = CGAffineTransform(scaleX: 5, y: 5)

        return filter.outputImage?.transformed(by: transform)
    }
    
    private func makeImageData(address: String) -> Data? {
        guard let ciImage = image(from: address) else { return nil }
        let uiImage = UIImage(ciImage: ciImage, scale: 1, orientation: UIImage.Orientation.up)
        return uiImage.pngData()
    }
    
    private func addCache(_ imageData: Data, for address: String) {
        var cache = self.cache() ?? .init()
        cache[address] = imageData
        cacheRepository.save(cache, atKey: .qrCodes)
    }
    
    private func imageCache(address: String) -> Data? {
        nil//cache()?[address]
    }
    
    private func cache() -> [String: Data]? {
        cacheRepository.load(atKey: .qrCodes)
    }
}

private extension CacheKey {
    static let qrCodes = CacheKey(value: "qrCodes")
}

private extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}

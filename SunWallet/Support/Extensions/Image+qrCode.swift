import SwiftUI

extension Image {
    
    init(qrCode: String) {
        let data = qrCode.data(using: String.Encoding.isoLatin1)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            fatalError("System error")
        }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 100, y: 100)

        guard let output = filter.outputImage?.transformed(by: transform) else {
            fatalError("Something went wrong")
        }
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(output, from: output.extent)!
        self.init(decorative: cgImage, scale: 1)
    }
}

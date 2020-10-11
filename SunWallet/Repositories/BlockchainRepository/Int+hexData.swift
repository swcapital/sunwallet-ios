import Foundation

extension Int {
    var hexData: Data {
        let string = String(format:"%02x", self)
        print(string)
        return Data(hexString: string)!
    }
}

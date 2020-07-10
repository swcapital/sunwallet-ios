import Foundation

extension String: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(Self.self)
    }
}

import Foundation

extension String: Identifiable {
    public var id: ObjectIdentifier {
        ObjectIdentifier(Self.self)
    }
    
    
    /// Needs for smooth animations.
    /// When label are constantly changing, this constant prevents trailing truncating dots `...`
    static let extraSpace = "  "
}

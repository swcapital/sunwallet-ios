import Foundation

extension String: Identifiable {
    
    public var id: String {
        self
    }
    
    /// Needs for smooth animations.
    /// When label are constantly changing, this constant prevents trailing truncating dots `...`
    static let extraSpace = "  "
    
    var doubleValue: Double {
        Double(self) ?? 0
    }
}

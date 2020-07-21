import Foundation
import Combine

class UserSettingsStore: ObservableObject {
    
    @UserDefault("currency", defaultValue: Locale.current.currencyCode ?? "USD")
    var currency: String
    
    @UserDefault("favorites", defaultValue: [.btc , .eth])
    var favorites: [Asset]
}

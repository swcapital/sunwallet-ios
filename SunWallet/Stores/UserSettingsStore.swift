import Foundation
import Combine

class UserSettingsStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("locale", defaultValue: Locale.current)
    private(set) var locale: Locale { didSet { objectWillChange.send() } }
    
    var userCurrency: Asset { locale.currencyCode.map { Asset($0) } ?? .usd }
    
    @UserDefault("favorites", defaultValue: [.btc , .eth])
    private(set) var favorites: [Asset] { didSet { objectWillChange.send() } }
}

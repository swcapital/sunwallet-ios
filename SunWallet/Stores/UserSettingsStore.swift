import Foundation
import Combine

class UserSettingsStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("currency", defaultValue: Locale.current.currencyCode ?? "USD")
    var currency: String { didSet { objectWillChange.send() } }
    
    @UserDefault("favorites", defaultValue: [.btc , .eth])
    private(set) var favorites: [Asset] { didSet { objectWillChange.send() } }
}

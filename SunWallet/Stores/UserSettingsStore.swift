import Foundation
import Combine

class UserSettingsStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("currency", defaultValue: "USD")
    var currency: String { didSet { objectWillChange.send() } }
    
    @UserDefault("favorites", defaultValue: [.btc , .eth])
    var favorites: [Asset] { didSet { objectWillChange.send() } }
}

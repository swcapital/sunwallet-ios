import Foundation
import Combine

class AppState: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("loggedIn", defaultValue: false)
    var loggedIn: Bool { willSet { objectWillChange.send() } }
}

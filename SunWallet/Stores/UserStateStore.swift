import Foundation
import Combine

class UserStateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("loggedIn", defaultValue: false)
    private(set) var loggedIn: Bool { willSet { objectWillChange.send() } }
    
    
    func logIn() {
        loggedIn = true
    }
}

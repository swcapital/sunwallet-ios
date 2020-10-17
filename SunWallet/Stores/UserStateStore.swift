import Foundation
import Combine

class AppStateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("loggedIn", defaultValue: false)
    private(set) var loggedIn: Bool { willSet { objectWillChange.send() } }
    
    
    func logIn() {
        loggedIn = true
    }
}

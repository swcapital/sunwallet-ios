import Foundation
import Combine

class AppStateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("loggedIn", defaultValue: false)
    private(set) var loggedIn: Bool { didSet { objectWillChange.send() } }
    
    
    func logIn() {
        loggedIn = true
    }
    
    func logOut() {
        loggedIn = false
    }
}

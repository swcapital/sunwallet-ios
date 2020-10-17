import Foundation
import Combine

class AppStateStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    let walletStore: WalletStore

    @UserDefault("loggedIn", defaultValue: false)
    private(set) var loggedIn: Bool { didSet { objectWillChange.send() } }
    
    init(walletStore: WalletStore) {
        self.walletStore = walletStore
    }
    
    func logIn() {
        loggedIn = true
    }
    
    func logOut() {
        walletStore.reset()
        loggedIn = false
    }
}

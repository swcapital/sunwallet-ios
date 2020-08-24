import Combine
import Foundation

private let masterKeysKey = "masterKeys"

class WalletStore: ObservableObject {
    
    @UserDefault("wallets", defaultValue: [])
    private(set) var wallets: [Wallet]  { didSet { objectWillChange.send() } }
    
    func loadMasterKeys(hint: String) -> [MasterKey]? {
        let keychain = KeychainRepository()
        return keychain.loadValue(atKey: masterKeysKey, accessHint: hint)
    }
    
    func save(masterKeys: [MasterKey]) -> Bool {
        let keychain = KeychainRepository()
        return keychain.saveValue(masterKeys, atKey: masterKeysKey)
    }
    
    func save(wallets: [Wallet]) {
        self.wallets = wallets
    }
    
    func reset() {
        wallets = []
    }
}

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
    
    @discardableResult
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
    
    func remove(wallet: Wallet) {
        var wallets = self.wallets
        wallets.removeAll(where: { $0.address == wallet.address })
        
        if wallets.contains(where: { $0.masterKeyID == wallet.masterKeyID }) {
            guard var masterKeys = loadMasterKeys(hint: "Remove wallet") else { return }
            masterKeys.removeAll(where: { $0.id == wallet.masterKeyID })
            save(masterKeys: masterKeys)
        }
        
        save(wallets: wallets)
    }
}

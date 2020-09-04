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
    
    func add(masterKeys: [MasterKey]) -> Bool {
        let existedMasterKeys = loadMasterKeys(hint: "Adding master keys") ?? []
        let keychain = KeychainRepository()
        return keychain.saveValue(existedMasterKeys + masterKeys, atKey: masterKeysKey)
    }
    
    func save(wallets: [Wallet]) {
        self.wallets = wallets
    }
    
    func add(wallets: [Wallet]) {
        self.wallets += wallets
    }
    
    func reset() {
        wallets = []
    }
    
    func remove(wallet: Wallet) {
        var wallets = self.wallets
        wallets.removeAll(where: { $0.address == wallet.address })
        
        if wallets.contains(where: { $0.masterKeyID == wallet.masterKeyID }) {
            removeMasterKey(id: wallet.masterKeyID)
        }
        
        save(wallets: wallets)
    }
    
    private func removeMasterKey(id: UUID) {
        guard var masterKeys = loadMasterKeys(hint: "Remove wallet") else { return }
        masterKeys.removeAll(where: { $0.id == id })
        save(masterKeys: masterKeys)
    }
    
    private func save(masterKeys: [MasterKey]) {
        let keychain = KeychainRepository()
        _ = keychain.saveValue(masterKeys, atKey: masterKeysKey)
    }
}

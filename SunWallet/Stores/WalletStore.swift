import Combine
import Foundation
import HDWalletKit

private let masterKeysKey = "masterKeys"

class WalletStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("masterKeys", defaultValue: [])
    private(set) var masterKeys: [MasterKeyInfo]
    
    @UserDefault("wallets", defaultValue: [])
    private(set) var wallets: [Wallet] { willSet { objectWillChange.send() } }
    
    func createWallets(for currencies: [WalletCurrency]) -> Bool {
        let mnemonic = Mnemonic.create()
        return createWallets(for: currencies, mnemonic: mnemonic)
    }
    
    func restoreWallets() -> Bool {
        let masterKeys = loadMasterKeys(hint: "Restore previous Master Keys")
        if !masterKeys.isEmpty {
            updateWalletInfo(masterKeys: masterKeys)
        }
        return !masterKeys.isEmpty
    }
    
    func importWallets(for currencies: [WalletCurrency], mnemonic: String) -> Bool {
        createWallets(for: currencies, mnemonic: mnemonic)
    }
    
    func availableMasterKeys(for currency: WalletCurrency) -> [MasterKeyInfo] {
        masterKeys.filter { !$0.currencies.contains(currency) }
    }
    
    private func createWallets(for currencies: [WalletCurrency], mnemonic: String) -> Bool {
        guard currencies.count > 0 else { return false }
        
        let masterKey = MasterKey(mnemonic: mnemonic, currencies: currencies)
        var masterKeys = loadMasterKeys(hint: "Save Master Key")
        masterKeys.append(masterKey)
        guard save(masterKeys: masterKeys) else { return false }
        
        updateWalletInfo(masterKeys: masterKeys)
        return true
    }
    
    private func loadMasterKeys(hint: String) -> [MasterKey] {
        let keychain = KeychainRepository()
        return keychain.loadValue(atKey: masterKeysKey, accessHint: hint) ?? []
    }
    
    private func save(masterKeys: [MasterKey]) -> Bool {
        let keychain = KeychainRepository()
        return keychain.saveValue(masterKeys, atKey: masterKeysKey)
    }
    
    private func updateWalletInfo(masterKeys: [MasterKey]) {
        self.masterKeys = masterKeys.map { MasterKeyInfo(id: $0.id, title: $0.title, currencies: $0.currencies) }
        self.wallets = masterKeys.map { makeWallets(for: $0) }.reduce([], +)
    }
    
    private func makeWallets(for masterKey: MasterKey) -> [Wallet] {
        masterKey.currencies.map { currency -> Wallet in
            let seed = Mnemonic.createSeed(mnemonic: masterKey.mnemonic)
            let wallet = HDWalletKit.Wallet(seed: seed, coin: currency.coin)
            let account = wallet.generateAccount()
            return Wallet(address: account.address, currency: currency, masterKeyID: masterKey.id)
        }
    }
}

private extension WalletCurrency {
    var coin: Coin {
        switch self {
        case .btc: return .bitcoin
        case .eth: return .ethereum
        }
    }
}

import Combine
import Foundation
import HDWalletKit

private let masterKeysKey = "masterKeys"

class WalletStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("masterKeys", defaultValue: [])
    private(set) var masterKeys: [MasterKeyInfo]
    
    @UserDefault("wallets", defaultValue: [])
    private(set) var wallets: [Wallet] { didSet { objectWillChange.send() } }
    
    func createWallets(for assets: [Asset]) -> Bool {
        let mnemonic = Mnemonic.create()
        return createWallets(for: assets, mnemonic: mnemonic)
    }
    
    func restoreWallets() -> Bool {
        let masterKeys = loadMasterKeys(hint: "Restore previous Master Keys")
        if !masterKeys.isEmpty {
            updateWalletInfo(masterKeys: masterKeys)
        }
        return !masterKeys.isEmpty
    }
    
    func importWallets(for assets: [Asset], mnemonic: String) -> Bool {
        createWallets(for: assets, mnemonic: mnemonic)
    }
    
    func availableMasterKeys(for asset: Asset) -> [MasterKeyInfo] {
        masterKeys.filter { !$0.assets.contains(asset) }
    }
    
    private func createWallets(for assets: [Asset], mnemonic: String) -> Bool {
        guard assets.count > 0 else { return false }
        
        let masterKey = MasterKey(mnemonic: mnemonic, assets: assets)
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
        self.masterKeys = masterKeys.map { MasterKeyInfo(id: $0.id, title: $0.title, assets: $0.assets) }
        self.wallets = masterKeys.map { makeWallets(for: $0) }.reduce([], +)
    }
    
    private func makeWallets(for masterKey: MasterKey) -> [Wallet] {
        masterKey.assets.map { asset -> Wallet in
            let seed = Mnemonic.createSeed(mnemonic: masterKey.mnemonic)
            let wallet = HDWalletKit.Wallet(seed: seed, coin: asset.coin)
            let account = wallet.generateAccount()
            return Wallet(address: account.address, asset: asset, masterKeyID: masterKey.id)
        }
    }
}

private extension Asset {
    var coin: Coin {
        switch self {
        case .btc: return .bitcoin
        case .eth: return .ethereum
        default: fatalError()
        }
    }
}

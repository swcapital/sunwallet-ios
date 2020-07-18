import Foundation
import HDWalletKit

struct MasterKey: Codable {
    let id: UUID
    let mnemonic: String
    
    init(mnemonic: String) {
        self.id = UUID()
        self.mnemonic = mnemonic
    }
    
    init() {
        self.id = UUID()
        self.mnemonic = Mnemonic.create()
    }
    
    func wallets() -> [Wallet] {
        let assets: [Asset] = [.eth, .btc]
        return assets.map { asset -> Wallet in
            let seed = Mnemonic.createSeed(mnemonic: self.mnemonic)
            let wallet = HDWalletKit.Wallet(seed: seed, coin: asset.coin)
            let account = wallet.generateAccount()
            return Wallet(address: account.address, title: account.address, asset: asset, masterKeyID: self.id)
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

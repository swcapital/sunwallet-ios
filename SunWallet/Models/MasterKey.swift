import Foundation
import TrustWalletCore

private let passphrase = ""

struct MasterKey: Codable {
    let id: UUID
    let mnemonic: String
    
    init(mnemonic: String) {
        self.id = UUID()
        self.mnemonic = mnemonic
    }
    
    init() {
        self.id = UUID()
        self.mnemonic = HDWallet(strength: 128, passphrase: passphrase).mnemonic
    }
    
    func wallets() -> [Wallet] {
        let assets: [Asset] = [.eth, .btc]
        return assets.map { asset -> Wallet in            
            let wallet = HDWallet(mnemonic: self.mnemonic, passphrase: passphrase)
            let address = wallet.getAddressForCoin(coin: asset.coin)
            return Wallet(address: address, title: asset.title, asset: asset, masterKeyID: self.id)
        }
    }
}

private extension Asset {
    var coin: CoinType {
        switch self {
        case .btc: return .bitcoin
        case .eth: return .ethereum
        default: fatalError()
        }
    }
}

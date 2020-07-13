import SwiftUI

extension BootstrapWalletsScreen {
    struct WalletList: View {        
        @EnvironmentObject
        var walletStore: WalletStore
        
        var body: some View {
            VStack {
                Divider()
                ForEach(walletStore.wallets, id: \.address) { wallet in
                    VStack {
                        HStack {
                            Image(wallet.asset.imageName)
                            VStack(alignment: .leading) {
                                Text("Address: \(wallet.address)")
                                    .lineLimit(1)
                                    .font(.headline)
                                Text("Master Key: \(self.masterKey(for: wallet)?.title ?? "Unknown")")
                                    .lineLimit(1)
                                    .font(.caption)
                            }
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
        }
        
        private func masterKey(for wallet: Wallet) -> MasterKeyInfo? {
            walletStore.masterKeys.first(where: { wallet.masterKeyID == $0.id })
        }
    }
}

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let walletStore = WalletStore()
    private let userSettingsStore = UserSettingsStore()
    private let assetInfoStore = AssetInfoStore()
    
    private lazy var blockchainStore = BlockchainStore(walletStore: walletStore)
    private lazy var appStateStore = AppStateStore(walletStore: walletStore)
    private lazy var historyStore = HistoryStore(userSettingsStore: userSettingsStore)
    private lazy var walletsHistoryStore = WalletsHistoryStore(
        historyStore: historyStore,
        blockchainStore: blockchainStore,
        walletStore: walletStore
    )
    private lazy var accountsStore = AccountsStore(historyStore: historyStore, walletsHistoryStore: walletsHistoryStore)
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let contentView = RootView()
            .environmentObject(appStateStore)
            .environmentObject(blockchainStore)
            .environmentObject(historyStore)
            .environmentObject(walletsHistoryStore)
            .environmentObject(walletStore)
            .environmentObject(userSettingsStore)
            .environmentObject(DataSource())
            .environmentObject(assetInfoStore)
            .environmentObject(accountsStore)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func resetUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}

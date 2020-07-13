import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let appStateStore = AppStateStore()
    private let walletStore = WalletStore()
    private let userSettingsStore = UserSettingsStore()
    
    private lazy var blockchainStore = BlockchainStore(walletStore: walletStore)
    private lazy var historyStore = HistoryStore(userSettingsStore: userSettingsStore)
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let contentView = RootView()
            .environmentObject(appStateStore)
            .environmentObject(blockchainStore)
            .environmentObject(historyStore)
            .environmentObject(walletStore)
            .environmentObject(userSettingsStore)
            .environmentObject(DataSource())

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

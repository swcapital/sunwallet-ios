import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let stateStore: UserStateStore = .init()
    private let historyStore = BootstrapHistoryStore()
    private let walletStore = WalletStore()
    private lazy var blockchainStore = BlockchainStore(walletStore: walletStore)
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let contentView = RootView()
            .environmentObject(blockchainStore)
            .environmentObject(historyStore)
            .environmentObject(stateStore)
            .environmentObject(walletStore)
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

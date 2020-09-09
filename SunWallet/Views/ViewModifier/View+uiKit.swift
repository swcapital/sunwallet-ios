import SwiftUI

extension View {
    
    private func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else { return nil }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    @discardableResult
    func present(_ viewController: UIViewController) -> Bool {
        guard let source = topMostViewController() else { return false }
        
        viewController.popoverPresentationController?.sourceView = source.view
        source.present(viewController, animated: true)
        return true
    }
    
    @discardableResult
    func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.excludedActivityTypes = excludedActivityTypes
        //viewController.popoverPresentationController?.sourceView = source.view
        
        return present(viewController)
    }
}

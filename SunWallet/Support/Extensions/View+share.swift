import SwiftUI

extension View {
    
    @discardableResult
    func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            return false
        }
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.excludedActivityTypes = excludedActivityTypes
        viewController.popoverPresentationController?.sourceView = source.view
        source.present(viewController, animated: true)
        return true
    }
}

import SwiftUI

struct ScanerView: UIViewControllerRepresentable {
    @Binding var content: String?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanerView>) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.completion = {
            self.content = $0
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: UIViewControllerRepresentableContext<ScanerView>) {
    }
}

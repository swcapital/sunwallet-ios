import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    // MARK:- Bindings
    @Binding var animating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.style = .large
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if animating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

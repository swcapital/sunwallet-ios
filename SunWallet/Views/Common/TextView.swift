import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.font = .systemFont(ofSize: 15)
        textView.isScrollEnabled = true
        textView.autocorrectionType = .no
        textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        
        textView.returnKeyType = .done

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        uiView.text = text
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard text != "\n" else {
                textView.resignFirstResponder()
                return false
            }
            
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}

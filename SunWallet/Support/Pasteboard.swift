import SwiftUI
import MobileCoreServices

enum Pasteboard {
    
    static func copy(_ string: String) {
        UIPasteboard.general.setValue(string, forPasteboardType: kUTTypePlainText as String)
    }
}

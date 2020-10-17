import Foundation

extension NativeCurrencyView {
    struct Currency {
        let code: String
        let title: String
        
        init(code: String) {
            self.code = code
            self.title = Locale.current.localizedString(forCurrencyCode: code) ?? ""
        }
        
        func contains(text: String) -> Bool {
            let text = text.uppercased()
            return code.uppercased().contains(text) || title.uppercased().contains(text)
        }
    }
}

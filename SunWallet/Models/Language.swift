import Foundation

struct Language: Identifiable {
    static var list: [Language] = Locale.isoRegionCodes.map { Language(code: $0) }
    
    var id: String { code }
    
    let code: String
    let title: String
    let flag: String
        
    init(code: String) {
        self.code = code
        self.title = Locale.current.localizedString(forRegionCode: code)  ?? "Fuck"
        self.flag = Language.emojiFlag(regionCode: code)!
    }
    
    private static func emojiFlag(regionCode: String) -> String? {
        return regionCode.uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .reduce("", +)
    }
}

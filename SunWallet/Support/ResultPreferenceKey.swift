import SwiftUI

struct ResultPreferenceKey: PreferenceKey {
    static var defaultValue: Bool?

    static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
        value = nextValue()
    }
}

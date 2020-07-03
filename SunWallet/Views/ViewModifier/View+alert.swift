import SwiftUI

extension View {
    func alert(error: Binding<String?>) -> some View {
        return self.alert(item: error) { error in
            Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("Got it!")))
        }
    }
}

extension String: Identifiable {
    public var id: Int {
        self.hashValue
    }
}

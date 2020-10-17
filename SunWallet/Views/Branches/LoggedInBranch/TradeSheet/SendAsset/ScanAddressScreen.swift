import SwiftUI

struct ScanAddressScreen: View {
    @Binding var address: String?
    
    var body: some View {
        ScanerView(content: $address)
    }
}

struct ScanAddressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScanAddressScreen(address: .constant(""))
    }
}

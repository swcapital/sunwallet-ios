import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Image("price-notifications")
            Text("Instant notifications")
                .font(.title)
            Text("We can notify you when something important happens, like your balance changes or there's a security alert.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {}) {
                Text("Turn on notifications")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
            
            Button(action: {}) {
                Text("Skip for now")
                    .foregroundColor(.blueGray)
                    .padding()
            }
        }
    }
}

struct NotificationPopup_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

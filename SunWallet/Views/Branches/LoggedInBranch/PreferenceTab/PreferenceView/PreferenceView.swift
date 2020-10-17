import SwiftUI

struct PreferenceView: View {
    @EnvironmentObject
    var appStateStore: AppStateStore
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
    // MARK:- Subviews
    private var rows: some View {
        VStack {
            makeRow(title: "Limits and features", subtitle: "Level 2")
            makeRow(
                title: "Native currency",
                subtitle: userSettingsStore.currency,
                destination: NativeCurrencyView()
            )
            makeRow(title: "Country", subtitle: "Germany")
            makeRow(title: "Phone numbers")
            makeRow(title: "Notification Settings")
            makeRow(title: "Privacy")
            
            Button("Logout") { self.appStateStore.logOut() }
                .padding()
                .buttonStyle(PrimaryButtonStyle())
        }
    }
    private var scrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Account")
                    .fontWeight(.semibold)
                    .font(.title)
                    .padding()
                    .frame(height: 30.0)
                
                Divider()

                rows
            }
        }
    }
    
    var body: some View {
        NavigationView {
            scrollView
        }
    }
    
    // MARK:- Methods
    func makeRow<Destination: View>(title: String, subtitle: String = "", destination: Destination) -> some View {
        VStack {
            NavigationLink(destination: destination) {
                PreferenceCell(title: title, subtitle: subtitle)
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
        }
    }
    
    func makeRow(title: String, subtitle: String = "", action: @escaping () -> Void) -> some View {
        VStack {
            Button(action: action) {
                PreferenceCell(title: title, subtitle: subtitle)
            }
            Divider()
        }
    }
    
    func makeRow(title: String, subtitle: String = "") -> some View {
        makeRow(title: title, subtitle: subtitle, destination: Text(title))
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}

import SwiftUI
import BottomBar_SwiftUI

let items: [BottomBarItem] = [
    BottomBarItem(icon: Image("tab-bar-home"), title: "Home", color: Color.blueColor),
    BottomBarItem(icon: Image("tab-bar-search"), title: "Search", color: Color.greenColor),
    BottomBarItem(icon: Image("tab-bar-discover"), title: "Discover", color: Color.yellowColor),
    BottomBarItem(icon: Image("tab-bar-notifications"), title: "Notifications", color: Color.redColor)
]


struct BasicView: View {
    let item: BottomBarItem

    var detailText: String {
    "\(item.title) Detail"
}

var followButton: some View {
    Button(action: openTwitter) {
        VStack {
            Text("Developed by Bezhan Odinaev")
                .font(.headline)
                .foregroundColor(item.color)

            Text("@smartvipere75")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

var destination: some View {
    Text(detailText)
        .navigationBarTitle(Text(detailText))
}

var navigateButton: some View {
    NavigationLink(destination: destination) {
        ZStack {
            Rectangle()
                .fill(item.color)
                .cornerRadius(8)
                .frame(height: 52)
                .padding(.horizontal)

            Text("Navigate")
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

func openTwitter() {
    guard let url = URL(string: "https://twitter.com/smartvipere75") else {
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}

var body: some View {
    VStack {
        Spacer()

        followButton

        Spacer()

        navigateButton
        }
    }
}

struct BottomBarDemo : View {
    @State private var selectedIndex: Int = 0

    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }

var body: some View {
        NavigationView {
            VStack {
                BasicView(item: selectedItem)
                    .navigationBarTitle(Text(selectedItem.title))
                BottomBar(selectedIndex: $selectedIndex, items: items)
            }
        }
    }
}

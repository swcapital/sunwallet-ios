import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PageView: View {
    var body: some View {
        TabView {
            ForEach(0..<30) { i in
                ZStack {
                    Color.black
                    Text("Row: \(i)").foregroundColor(.white)
                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
            .padding(.all, 10)
        }
        .frame(width: UIScreen.main.bounds.width, height: 200)
        .tabViewStyle(PageTabViewStyle())
    }
}

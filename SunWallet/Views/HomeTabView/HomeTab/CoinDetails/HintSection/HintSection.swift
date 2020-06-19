import SwiftUI

struct HintSection: View {
    var body: some View {
        Section {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("When's the best time to buy?")
                        .font(.headline)
                    Text("Timing any investment is hard, which is why many investorsuse dollar cost averaging.")
                }
                Image("recurring-buys")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
            }
            .padding()
        }
    }
}


struct HintSection_Previews: PreviewProvider {
    static var previews: some View {
        HintSection()
    }
}

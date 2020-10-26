import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Match", subTitle: "Match the gradients by moving the Red, Green and Blue sliders for the left and right colors.", imageName: "crypto-exchange")

            InformationDetailView(title: "Precise", subTitle: "More precision with the steppers to get that 100 score.", imageName: "earn-interest")

            InformationDetailView(title: "Score", subTitle: "A detailed score and comparsion of your gradient and the target gradient.", imageName: "portfolio")
        }
        .padding(.horizontal)
    }
}

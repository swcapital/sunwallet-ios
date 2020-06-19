import SwiftUI

extension View {
    
    private func backButton(presentationMode: Binding<PresentationMode>) -> some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "arrow.left").foregroundColor(Color.darkGray)
        }
    }
    
    func navigationBarBackButton(presentationMode: Binding<PresentationMode>) -> some View {
        self.navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: backButton(presentationMode: presentationMode)
            )
    }
}

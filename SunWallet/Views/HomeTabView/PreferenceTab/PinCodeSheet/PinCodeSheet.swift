import SwiftUI

struct PinCodeSheet: View {
    // MARK:- Bindings
    @Binding var result: [Int]?
    
    // MARK:- States
    @State var digits: [Int] = []
    
    // MARK:- Calculated Variables
    private var digitsWrapper: Binding<[Int]> {
        Binding<[Int]>(
            get: { self.digits },
            set: {
                self.digits = $0
                self.onDigitsUpdate()
            }
        )
    }
    
    // MARK:- Subviews
    private var dotsView: some View {
        HStack(spacing: 16) {
            DotView(active: digits.count > 0)
            DotView(active: digits.count > 1)
            DotView(active: digits.count > 2)
            DotView(active: digits.count > 3)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("sunwallet")
                .font(.largeTitle)
            
            Text("Enter a new PIN")
                .font(.headline)
                .padding(8)
            
            dotsView
            
            Spacer()
            
            PinKeyboardView(cancelAction: self.onCancelAction, digits: digitsWrapper)
                .padding()
        }
        .foregroundColor(.white)
        .background(Color.primaryBlue.edgesIgnoringSafeArea(.all))
    }
    
    // MARK:- Methods
    private func onCancelAction() {
        result = nil
    }
    
    private func onDigitsUpdate() {
        if digits.count == 4 {
            result = digits
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PinCodeSheet(result: .constant(nil))
    }
}

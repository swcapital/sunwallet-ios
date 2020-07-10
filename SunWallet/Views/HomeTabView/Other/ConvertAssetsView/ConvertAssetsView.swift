import SwiftUI

struct ConvertAssetsView: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    
    // MARK:- States
    @State private var showDirectionView = false
    @State private var amountLabel = "0"
    @State private var assetExchange = AssetExchange(
        source: TestData.randomAsset,
        destination: TestData.randomAsset
    )

    // MARK:- Calculated Variables
    private var isPreviewButtonDisabled: Bool {
        assetExchange.value == 0
    }
    
    // MARK:- Subviews
    private var titleView: some View {
        VStack() {
            Text("Convert \(assetExchange.source.title)")
                .font(.headline)

            Text("Your \(assetExchange.source.code) balance = 0,00 US$")
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(12)

            Text("\(self.amountLabel) US$")
                .font(.system(size: 56))
                .foregroundColor(Color.primaryBlue)
            
            convertAllButton
                .padding(8)
        }
    }
    private var buttonBorder: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.gray, lineWidth: 0.5)
    }
    private var convertAllButton: some View {
        Button(action: {}) {
            Text("Convert All")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .overlay(buttonBorder)
        }
    }
    private var previewButton: some View {
        Button("Preview Convert") {
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isPreviewButtonDisabled)
        .padding(.vertical)
        .disabled(isPreviewButtonDisabled)
        .padding(.horizontal)
    }
    private var closeButton: some View {
        Button(action: {}) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
        }
    }
    private var content: some View {
        VStack {
            titleView

            Spacer()
            
            Divider()
            
            ExchangeDirectionButton(assetExchange: assetExchange, action: onChangeDirection)
            
            Divider()
            
            Keyboard(number: $assetExchange.value, label: $amountLabel)
            
            previewButton
        }
    }
    private var blurView: some View {
        Rectangle()
            .foregroundColor(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture(perform: onChangeDirection)
    }

    var body: some View {
        ZStack {
            content
                .padding(.vertical)
                .zIndex(0) // Needed for animation

            closeButton
                .position(x: 24, y: 24)

            if showDirectionView {
                blurView
                    .zIndex(1) // Needed for animation
                
                ExchangeDirectionView(onUserInput: onChangeDirection, exchange: $assetExchange)
                    .transition(.move(edge: .bottom))
                    .zIndex(2) // Needed for animation
            }
        }
    }

    // MARK:- Methods
    private func onChangeDirection() {
        withAnimation {
            self.showDirectionView.toggle()
        }
    }
}

struct ConvertAssetsView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertAssetsView()
            .environmentObject(DataSource())
    }
}

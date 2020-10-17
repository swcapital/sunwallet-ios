import SwiftUI

struct LinkCardView: View {
    // MARK:- States
    @State private var language: Language = Language.list.randomElement()!
    @State private var showLanguageList: Bool = false
    @State private var addressLine1: String = ""
    @State private var addressLine2: String = ""
    @State private var cardholderName: String = ""
    @State private var cardNumber: String = ""
    @State private var cardExpirationDate: String = ""
    @State private var cardCVC: String = ""
    @State private var postalCode: String = ""
    
    // MARK:- Subviews
    private var languageList: some View {
        List(Language.list) { language in
            self.text(for: language)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    self.language = language
                    self.showLanguageList = false
                })
        }
        .frame(height: 300)
        .zIndex(100)
    }
    private var languageButton: some View {
        PopupButton(text: self.text(for: language))
    }
    private var spacer: some View {
        Rectangle().fill(Color.clear).frame(height: 20)
    }
    private var countryRow: some View {
        makeRow(title: "Country") {
            languageButton
                .alignmentGuide(.languageVerticalAlignment, computeValue: { d in d[.bottom] })
                .contentShape(Rectangle())
                .onTapGesture(perform: { self.showLanguageList = true })
        }
    }
    private var addressLine1Row: some View {
        makeRow(title: "Address Line 1") {
            FocusingTextField(text: $addressLine1)
        }
    }
    private var addressLine2Row: some View {
        makeRow(title: "Address Line 2 (Optional)") {
            FocusingTextField(text: $addressLine2)
        }
    }
    private var cardHolderNameRow: some View {
        makeRow(title: "Name on card") {
            FocusingTextField(
                text: $cardholderName,
                color: .yellow,
                hint: "Please enter the name on your card"
            )
        }
    }
    private var cardNumberRow: some View {
        makeRow(title: "Card number") {
            FocusingTextField(
                text: $cardNumber,
                color: .yellow,
                label: "XXXX XXXX XXXX"
            ).background(
                HStack(spacing: 16) {
                    Image("visa")
                    Image("mastercard")
                }.offset(x: -16, y: -8),
                alignment: .trailing
            )
        }
    }
    private var cardSecretsRow: some View {
        HStack(spacing: 32) {
            makeRow(title: "Expiration") {
                FocusingTextField(text: $cardExpirationDate, label: "MM/YY")
            }
            makeRow(title: "CVC") {
                FocusingTextField(text: $cardCVC, label: "123")
            }
        }
    }
    private var postalCodeRow: some View {
        makeRow(title: "Postal code") {
            FocusingTextField(text: $postalCode)
        }
    }
    private var addCardButton: some View {
        Button(action: {}) {
            Text("Add Card")
                .padding(.vertical, 8)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(cardNumber.isEmpty)
    }
    private var inputRows: some View {
        VStack {
            countryRow
            addressLine1Row
            addressLine2Row
            cardHolderNameRow
            cardNumberRow
            cardSecretsRow
            postalCodeRow
        }
    }
    private var privacyPolicy: some View {
        Button(action: {}) {
            Text("By adding a new card, you agree to the ")
                .foregroundColor(Color.black)
            + Text("credit/debit card terms")
                .foregroundColor(Color.blue)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
    }
    private var proccessingInfo: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Image(systemName: "lock")
                    .font(.title)
                    .padding(4)
                Text("Proccessed by")
                    .font(.headline)
                Text("SunWallet")
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            .padding(24)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .languageAlignment) {
                VStack(alignment: .leading) {
                    Text("Please fill in the billing address for your credit/debit card")
                    inputRows
                    privacyPolicy
                    addCardButton
                }
                if showLanguageList {
                    languageList
                        .alignmentGuide(.languageVerticalAlignment, computeValue: { d in d[.top] })
                }
            }
            .padding()
            proccessingInfo
        }
        .navigationBarTitle("Link your card")
    }
    
    // MARK:- Methods
    private func text(for language: Language) -> Text {
        Text(language.flag + "  ").font(.largeTitle) + Text(language.title).baselineOffset(6)
    }
    
    private func makeRow<V: View>(title: String, @ViewBuilder content: () -> V) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .padding(.top, 24)
            content()
        }
    }
}

struct LinkCardView_Previews: PreviewProvider {
    static var previews: some View {
        LinkCardView()
    }
}

extension VerticalAlignment {
    private enum LanguageVerticalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.top]
        }
    }
    
    static let languageVerticalAlignment = VerticalAlignment(LanguageVerticalAlignment.self)
}

extension HorizontalAlignment {
    private enum LanguageHorizontalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }
    
    static let languageHorizontalAlignment = HorizontalAlignment(LanguageHorizontalAlignment.self)
}

extension Alignment {
    static let languageAlignment = Alignment(
        horizontal: .languageHorizontalAlignment,
        vertical: .languageVerticalAlignment
    )
}

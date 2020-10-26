import SwiftUI

struct NativeCurrencyView: View {
    private let allCurrencies: [Currency] = Locale.isoCurrencyCodes.map { .init(code: $0) }
    // MARK:- Environment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject
    var userSettingsStore: UserSettingsStore
    
    // MARK:- States
    @State private var searchText: String = ""
    
    // MARK:- Calculated Variables
    private var currencies: [Currency] {
        if searchText.isEmpty {
            return allCurrencies
        } else {
            return allCurrencies.filter {
                $0.contains(text: searchText)
            }
        }
    }
    
    var body: some View {
        List {
            SearchBar(text: self.$searchText)
            
            ForEach(currencies, id: \.code) { currency in
                Button(action: {
                    self.userSettingsStore.currency = currency.code
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        VStack(alignment:.leading) {
                            Text(currency.title)
                                .font(.body)
                            Text(currency.code)
                                .font(.footnote)
                        }
                        .frame(height: 44)
                        
                        Spacer()
                    }
                }
                
            }
        }
        .navigationBarTitle("Currencies", displayMode: .inline)
        .navigationBarBackButton(presentationMode: self.presentationMode)
    }
}

struct NextContentView_Previews: PreviewProvider {
    static var previews: some View {
        NativeCurrencyView()
            .environmentObject(UserSettingsStore())
    }
}

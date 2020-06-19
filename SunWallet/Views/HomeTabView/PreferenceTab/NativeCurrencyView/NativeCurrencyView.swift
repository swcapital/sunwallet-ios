import SwiftUI

struct NativeCurrencyView: View {
    // MARK:- Environment
    @EnvironmentObject var dataSource: DataSource
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK:- States
    @State private var searchText: String = ""
    
    // MARK:- Calculated Variables
    private var currencies: [Currency] {
        if searchText.isEmpty {
            return dataSource.currencies
        } else {
            let search = searchText.uppercased()
            return dataSource.currencies.filter {
                $0.title.uppercased().contains(search) || $0.subtitle.uppercased().contains(search)
            }
        }
    }
    
    var body: some View {
        List {
            SearchBar(text: self.$searchText)
            
            ForEach(currencies) { currency in
                VStack(alignment:.leading) {
                    Text(currency.title)
                        .font(.body)
                    Text(currency.subtitle)
                        .font(.footnote)
                }
                .frame(height: 44)
            }
        }
        .navigationBarTitle("Currencies", displayMode: .inline)
        .navigationBarBackButton(presentationMode: self.presentationMode)
    }
}

struct NextContentView_Previews: PreviewProvider {
    static var previews: some View {
        NativeCurrencyView()
            .environmentObject(DataSource())
    }
}

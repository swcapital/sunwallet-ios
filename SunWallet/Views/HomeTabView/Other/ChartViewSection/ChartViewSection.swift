import SwiftUI

struct ChartViewSection: View {
    // MARK:- Properties
    let valueHistory: ValueHistory
    let color: Color
    
    // MARK:- Bindings
    @Binding var selectedValue: Double?
    @Binding var selectedValueChange: Double?
    
    var body: some View {
        Section {
            CurrencyChartView(
                valueHistory: valueHistory,
                color: color,
                selectedValue: $selectedValue,
                selectedValueChange: $selectedValueChange
            )
            .padding(.bottom, 32)
        }
    }
}

struct ChartViewSection_Previews: PreviewProvider {
    static var previews: some View {
        ChartViewSection(
            valueHistory: TestData.randomAsset.valueHistory,
            color: .green,
            selectedValue: .constant(0),
            selectedValueChange: .constant(0)
        )
    }
}

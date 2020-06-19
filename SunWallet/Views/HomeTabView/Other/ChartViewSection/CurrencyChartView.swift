import SwiftUI

struct CurrencyChartView: View {
    // MARK:- Properties
    let valueHistory: ValueHistory
    let color: Color
    
    // MARK:- Bindings
    @Binding var selectedValue: Double?
    @Binding var selectedValueChange: Double?
    
    // MARK:- States
    @State private var selectedChartSource: Int = 0
    
    // MARK:- Calculated Variables
    private var selectedValueIndex: Binding<Int?> {
        Binding<Int?>(get: {
            0
        }, set: { newValue in
            guard let index = newValue, self.chartSource.indices.contains(index) else {
                self.selectedValue = nil
                self.selectedValueChange = nil
                return
            }
            self.selectedValue = self.chartSource[index]
            self.selectedValueChange = (index != 0) ? self.chartSource[index - 1] : 0
        })
    }
    private var chartSource: [Double] {
        switch selectedChartSource {
        case 0: return valueHistory.hourly
        case 1: return valueHistory.daily
        case 2: return valueHistory.weekly
        case 3: return valueHistory.monthly
        case 4: return valueHistory.yearly
        default: return valueHistory.all
        }
    }
    
    var body: some View {
        VStack {
            ChartView(values: self.chartSource, accentColor: color, selectedValueIndex: selectedValueIndex)
                .frame(height: 300)
                .padding()
            SegmentedControl(
                titles: ["1H", "1D", "1W", "1M", "1Y", "All"],
                selectedIndex: self.$selectedChartSource
            )
        }
    }
}

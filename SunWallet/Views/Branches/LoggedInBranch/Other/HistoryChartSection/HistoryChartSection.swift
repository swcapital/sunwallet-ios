import SwiftUI

struct HistoryChartSection: View {
    // MARK:- Properties
    let historySet: HistorySet
    let color: Color
    
    // MARK:- Bindings
    @Binding var selectedValue: Double?
    @Binding var selectedValueChange: Double?
    
    // MARK:- States
    @State private var selectedChartPeriod: Int = 0
    
    private var highlightedIndex: Binding<Int?> {
        Binding<Int?>(
            get: { nil },
            set: { newValue in
                let values = self.historyData(withPeriodIndex: self.selectedChartPeriod)
                let index = newValue ?? values.count - 1
                self.selectedValue = values[index].value
            }
        )
    }    

    private var chartTabs: [MultiChart.ChartTab] {
        [
            .init(title: "1H", values: historySet.hourly.onlyValues()),
            .init(title: "1D", values: historySet.daily.onlyValues()),
            .init(title: "1W", values: historySet.weekly.onlyValues()),
            .init(title: "1M", values: historySet.monthly.onlyValues()),
            .init(title: "1Y", values: historySet.yearly.onlyValues()),
            .init(title: "ALL", values: historySet.all.onlyValues()),
        ]
    }
    
    var body: some View {
        Section {
            MultiChart(
                tabs: chartTabs,
                color: color,
                tabIndex: $selectedChartPeriod,
                highlightedIndex: highlightedIndex
            )
        }
    }
    
    private func historyData(withPeriodIndex index: Int) -> [HistoryValue] {
        switch index {
        case 0: return historySet.hourly
        case 1: return historySet.daily
        case 2: return historySet.weekly
        case 3: return historySet.monthly
        case 4: return historySet.yearly
        default: return historySet.all
        }
    }
}

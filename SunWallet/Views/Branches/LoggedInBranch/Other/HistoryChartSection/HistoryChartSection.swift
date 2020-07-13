import SwiftUI

struct HistoryChartSection: View {
    // MARK:- Properties
    let exchangeHistory: ExchangeHistory
    let color: Color
    
    // MARK:- Bindings
    @Binding var selectedValue: Double?
    @Binding var selectedValueChange: Double?
    
    // MARK:- States
    @State private var selectedChartPeriod: Int = 0
    @State private var highlightedIndex: Int?
    
    
    // MARK:- Calculated Variables
    private var currentPrice: Double {
        let values = historyData(withPeriodIndex: selectedChartPeriod)
        let index = highlightedIndex ?? values.count - 1
        return values[index].close
    }
    private var currentPriceDiff: Double {
        let values = historyData(withPeriodIndex: selectedChartPeriod)
        let index = highlightedIndex ?? values.count - 1
        guard index > 0 else { return 0 }
        
        return values[index].close - values[index - 1].close
    }
    private var chartTabs: [MultiChart.ChartTab] {
        let historySet = exchangeHistory.historySet
        return [
            .init(title: "1H", values: historySet.hourly.rawValues()),
            .init(title: "1D", values: historySet.daily.rawValues()),
            .init(title: "1W", values: historySet.weekly.rawValues()),
            .init(title: "1M", values: historySet.monthly.rawValues()),
            .init(title: "1Y", values: historySet.yearly.rawValues()),
            .init(title: "ALL", values: historySet.all.rawValues()),
        ]
    }
    
    var body: some View {
        Section {
            MultiChart(
                tabs: chartTabs,
                color: color,
                tabIndex: $selectedChartPeriod,
                highlightedIndex: $highlightedIndex
            )
        }
    }
    
    private func historyData(withPeriodIndex index: Int) -> [TradeData] {
        let historySet = exchangeHistory.historySet
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

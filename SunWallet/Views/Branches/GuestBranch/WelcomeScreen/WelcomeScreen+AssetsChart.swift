import SwiftUI

extension WelcomeScreen {
    struct AssetsChart: View {
        let history: [ExchangeHistory]
        
        @EnvironmentObject
        var userSettingsStore: UserSettingsStore
        
        // MARK:- States
        @State private var selectedChartPeriod: Int = 0
        @State private var highlightedIndex: Int?
        @State private var selectedAssetIndex = 0
        
        // MARK:- Calculated Variables
        private var assetTitles: [String] {
            history.map { $0.source.code.uppercased() }
        }
        private var currentPrice: Double {
            let values = historyData(withPeriodIndex: selectedChartPeriod)
            let index = highlightedIndex ?? values.count - 1
            return values[index].value
        }
        private var termPriceDiff: Double {
            let values = historyData(withPeriodIndex: selectedChartPeriod)
            return (values.last?.value ?? 0) - (values.first?.value ?? 0)
        }
        private var chartTabs: [ChartTab] {
            let historySet = history[selectedAssetIndex].historySet
            return [
                .init(title: "1H", values: historySet.hourly.onlyValues()),
                .init(title: "1D", values: historySet.daily.onlyValues()),
                .init(title: "1W", values: historySet.weekly.onlyValues()),
                .init(title: "1M", values: historySet.monthly.onlyValues()),
                .init(title: "1Y", values: historySet.yearly.onlyValues()),
                .init(title: "ALL", values: historySet.all.onlyValues()),
            ]
        }
        private var periodTitle: String {
            ["This hour", "This day", "This week", "This month", "This year", "All time"][selectedChartPeriod]
        }
        
        // MARK:- Subviews
        private var chartView: some View {
            MultiChart(
                tabs: chartTabs,
                color: .white,
                tabIndex: $selectedChartPeriod,
                highlightedIndex: $highlightedIndex
            )
        }
        private var assetPicker: some View {
            HStack {
                VStack {
                    Divider()
                }
                Text("")
                ForEach(Array(assetTitles.enumerated()), id: \.offset) { index, title in
                    self.makeAssetButton(title: title, index: index)
                }
                Text("")
                VStack {
                    Divider()
                }
            }
        }
        private var leftAssetValue: some View {
            HStack {
                Spacer()
                VStack {
                    Text(currentPrice.currencyString(code: userSettingsStore.currency))
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                    Text("\(assetTitles[selectedAssetIndex]) price")
                        .font(.caption)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }
        private var rightAssetValue: some View {
            HStack {
                Spacer()
                VStack(spacing: 0.0) {
                    HStack(spacing: 4.0) {
                        Text(termPriceDiff.currencyString(code: userSettingsStore.currency) + .extraSpace)
                            .font(.headline)
                            .foregroundColor(Color.white)
                        
                        dynamicArrow
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text(periodTitle)
                        .font(.caption)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
        }
        private var assetValues: some View {
            HStack {
                leftAssetValue
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                rightAssetValue
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
        }
        
        private var dynamicArrow: some View {
            Image(systemName: termPriceDiff.isPositive ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .foregroundColor(termPriceDiff.isPositive ? .green : .red)
                .font(.caption)
        }
        
        
        var body: some View {
            VStack {
                assetPicker
                assetValues
                chartView
            }
        }
        
        // MARK:- Methods
        private func makeAssetButton(title: String, index: Int) -> some View {
            Button(title, action: { self.selectedAssetIndex = index })
                .lineLimit(1)
                .frame(width: 45)
                .foregroundColor(self.selectedAssetIndex == index ? .white : Color.white.opacity(0.7))
        }
        
        private func historyData(withPeriodIndex index: Int) -> [HistoryValue] {
            let historySet = history[selectedAssetIndex].historySet
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
}

import SwiftUI

extension WelcomeScreen {
    struct AssetsChart: View {
        let exchangeHistory: [ExchangeHistory]
        
        @EnvironmentObject
        var userSettingsStore: UserSettingsStore
        
        // MARK:- States
        @State private var selectedChartPeriod: Int = 0
        @State private var highlightedIndex: Int?
        @State private var selectedAssetIndex = 0
        
        // MARK:- Calculated Variables
        private var assetTitles: [String] {
            exchangeHistory.map { $0.source.code.uppercased() }
        }
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
        private var chartTabs: [ChartTab] {
            let historySet = exchangeHistory[selectedAssetIndex].historySet
            return [
                .init(title: "1H", values: historySet.hourly.rawValues()),
                .init(title: "1D", values: historySet.daily.rawValues()),
                .init(title: "1W", values: historySet.weekly.rawValues()),
                .init(title: "1M", values: historySet.monthly.rawValues()),
                .init(title: "1Y", values: historySet.yearly.rawValues()),
                .init(title: "ALL", values: historySet.all.rawValues()),
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
                        Text(currentPriceDiff.currencyString(code: userSettingsStore.currency) + .extraSpace)
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
            Image(systemName: currentPriceDiff.isPositive ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .foregroundColor(currentPriceDiff.isPositive ? .green : .red)
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
                .foregroundColor(self.selectedAssetIndex == index ? .white : Color.white.opacity(0.7))
        }
        
        private func historyData(withPeriodIndex index: Int) -> [TradeData] {
            let historySet = exchangeHistory[selectedAssetIndex].historySet
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

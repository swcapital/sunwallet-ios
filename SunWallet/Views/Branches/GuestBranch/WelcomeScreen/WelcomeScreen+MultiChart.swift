import SwiftUI

extension WelcomeScreen {
    struct ChartTab {
        let title: String
        let values: [Double]
    }
    
    struct MultiChart: View {
        // MARK:- Properties
        let tabs: [ChartTab]
        let color: Color
        
        // MARK:- Bindings
        @Binding var tabIndex: Int
        @Binding var highlightedIndex: Int?
        
        // MARK:- Calculated Variables
        private var currentValues: [Double] {
            tabs[tabIndex].values
        }
        private var titles: [String] {
            tabs.map { $0.title }
        }
        
        var body: some View {
            VStack {
                SegmentedControl(
                    titles: titles,
                    accentColor: .white,
                    labelsColor: Color.white.opacity(0.7),
                    selectedIndex: self.$tabIndex
                )
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                
                Chart(
                    values: self.currentValues,
                    accentColor: .white,
                    labelsColor: .white,
                    selectedValueIndex: $highlightedIndex
                )
                .frame(height: 200)
            }
        }
    }
}

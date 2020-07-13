import SwiftUI

struct MultiChart: View {
    struct ChartTab {
        let title: String
        let values: [Double]
    }
    
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
            Chart(
                values: self.currentValues,
                accentColor: color,
                labelsColor: .gray,
                selectedValueIndex: $highlightedIndex
            )
            .frame(height: 300)
            
            SegmentedControl(
                titles: titles,
                accentColor: .primaryBlue,
                labelsColor: .darkGray,
                selectedIndex: self.$tabIndex
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

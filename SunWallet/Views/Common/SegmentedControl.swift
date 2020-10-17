import SwiftUI

struct SegmentedControl: View {
    // MARK:- Properties
    let titles: [String]
    let accentColor: Color
    let labelsColor: Color
    
    // MARK:- Bindings
    @Binding var selectedIndex: Int
    
    init(
        titles: [String],
        accentColor: Color = .accentColor,
        labelsColor: Color = .gray,
        selectedIndex: Binding<Int>
    ) {
        self.titles = titles
        self.accentColor = accentColor
        self.labelsColor = labelsColor
        self._selectedIndex = selectedIndex
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<titles.count) { index in
                Button(action: { self.selectedIndex = index }) {
                    Text(self.titles[index])
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(self.color(for: index))                
            }
        }
    }
    
    // MARK:- Methods
    private func color(for index: Int) -> Color {
        selectedIndex == index ? accentColor : labelsColor
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(titles: ["1H", "1D", "1W", "1M", "1Y", "All"], selectedIndex: .constant(0))
    }
}

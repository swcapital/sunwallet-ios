import SwiftUI

struct Chart: View {
    // MARK:- Properties
    let values: [Double]
    let accentColor: Color
    let labelsColor: Color
    
    // MARK:- Bindings
    @Binding var selectedValueIndex: Int?
    
    init(
        values: [Double],
        accentColor: Color = .accentColor,
        labelsColor: Color = .gray,
        selectedValueIndex: Binding<Int?>
    ) {
        self.values = values
        self.accentColor = accentColor
        self.labelsColor = labelsColor
        self._selectedValueIndex = selectedValueIndex
        
        let minValue = values.min()!
        let maxValue = values.max()!
        
        self.points = values.map {
            ($0 - minValue) / (maxValue - minValue)
        }
    }
    
    // MARK:- States
    @State private var showOverlay = false
    @State private var overlayOffset: CGFloat = 0
    
    // MARK:- Calculated Variables
    private let points: [Double]
    
    private var maxPoint: CGPoint {
        let offset = CGFloat(points.firstIndex(of: 1)!) / CGFloat(points.count)
        return .init(x: offset, y: 0)
    }
    private var minPoint: CGPoint {
        let offset = CGFloat(points.firstIndex(of: 0)!) / CGFloat(points.count)
        return .init(x: offset, y: 1)
    }
    
    private var minValue: Double { values.min()! }
    private var maxValue: Double { values.max()! }
    
    // MARK:- Subviews
    private func dragGeture(geometery: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                self.showOverlay = true
                self.overlayOffset = value.location.x
                let xOffset = value.location.x / geometery.size.width
                let index = Int(CGFloat(self.points.count) * xOffset)
                self.selectedValueIndex = min(self.points.count - 1, max(0, index))
            }
            .onEnded { value in
                self.showOverlay = false
                self.selectedValueIndex = nil
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                self.makeMinMaxLabel(title: self.maxValue.currencyString)
                    .alignmentGuide(.leading) {
                        self.xPosition(at: self.maxPoint.x, in: geometry, d: $0)
                    }
                
                LineChartShape(points: .init(self.points))
                    .stroke(self.accentColor, style: .chart)
                    .frame(width: geometry.size.width)
                    .animation(.default)
                    .overlay(
                        ChartOverlay(
                            accentPoint: self.accentPointPosition(in: geometry),
                            color: self.accentColor
                        )
                        .opacity(self.showOverlay ? 1 : 0)
                    )
                
                self.makeMinMaxLabel(title: self.minValue.currencyString)
                    .alignmentGuide(.leading) {
                        self.xPosition(at: self.minPoint.x, in: geometry, d: $0)
                    }
            }
            .contentShape(Rectangle())
            .gesture(self.dragGeture(geometery: geometry))
        }
    }
    
    // MARK:- Methods
    private func xPosition(at offset: CGFloat, in geometry: GeometryProxy, d: ViewDimensions) -> CGFloat {
        let padding: CGFloat = 4
        let width = d[.trailing] - d[.leading]
        let absoluteOffset = (geometry.size.width - width - padding * 2) * CGFloat(offset) + padding
        return d[.leading] - absoluteOffset
    }

    private func accentPointPosition(in geometry: GeometryProxy) -> CGPoint {
        let xOffset = overlayOffset / geometry.size.width
        let index = Int(CGFloat(points.count) * xOffset)
        let normalizedIndex = min(points.count - 1, max(0, index))
        let y = points[normalizedIndex]
        return .init(x: xOffset, y: CGFloat(y))
    }
    
    private func makeMinMaxLabel(title: String) -> some View {
        // Trailing space is needed for preventing string truncating duaring animation
        Text(title + " ")
            .font(.callout)
            .foregroundColor(self.labelsColor)
            .animation(.default)
    }
}

private struct ChartViewPreview: View {
    let data1 = [Double].init(initial: 4, range: -12..<12, count: 8)
    let data2 = [Double].init(initial: 8, range: -12..<12, count: 8)
    
    @State private var selected = false
    
    var body: some View {
        VStack {
            Chart(
                values: selected ? data1 : data2,
                selectedValueIndex: .constant(0)
            )
            Button("Push me") {
                withAnimation {
                    self.selected.toggle()
                }
            }
        }
    }
}

private struct ChartView_Previews: PreviewProvider {
    
    fileprivate static var previews: some View {
        ChartViewPreview()
    }
}

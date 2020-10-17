import SwiftUI

struct LineChartShape: Shape {
    // MARK:- Properties
    var points: AnimatableVector
    
    var animatableData: AnimatableVector {
        set { self.points = newValue }
        get { return self.points }
    }
    
    func path(in rect: CGRect) -> Path {
        let values = points.values
        let points = makePoints(fromValues: values, in: rect)
        return lineChart(points: points)
    }
    
    // MARK:- Methods
    private func makePoints(fromValues values: [Double], in rect: CGRect) -> [CGPoint] {
        guard values.count > 0 else { return [] }
        
        var maxValue = values.max()!
        var minValue = values.min()!
        if minValue == maxValue {
            maxValue += 0.9
            minValue -= 0.1
        }
        
        let horizontalStep = rect.size.width / CGFloat(values.count - 1)
        let verticleStep = rect.size.height / CGFloat(maxValue - minValue)
        return values.enumerated().map { i, value in
            CGPoint(
                x: rect.minX + horizontalStep * CGFloat(i),
                y: rect.maxY - verticleStep * CGFloat(value - minValue)
            )
        }
    }
    
    private func lineChart(points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        path.addLines(points)
        return path
    }
}

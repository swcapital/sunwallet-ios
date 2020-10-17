import Foundation

@_functionBuilder
public struct BarBuilder{}

public extension BarBuilder{
    static func buildBlock(_ items: BottomBarItem...) -> [BottomBarItem]{
        items
    }
}

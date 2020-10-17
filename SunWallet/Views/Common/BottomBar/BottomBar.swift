import SwiftUI

public struct BottomBar : View {
    @Binding public var selectedIndex: Int
    
    public let items: [BottomBarItem]
    
    public init(selectedIndex: Binding<Int>, items: [BottomBarItem]) {
        self._selectedIndex = selectedIndex
        self.items = items
    }
    
    
    public init(selectedIndex: Binding<Int>, @BarBuilder items: () -> [BottomBarItem]){
        self = BottomBar(selectedIndex: selectedIndex,
                         items: items())
    }
    
    
    public init(selectedIndex: Binding<Int>, item: BottomBarItem){
        self = BottomBar(selectedIndex: selectedIndex,
                         items: [item])
    }
    
    
    func itemView(at index: Int) -> some View {
        Button(action: {
            withAnimation { self.selectedIndex = index }
        }) {
            BottomBarItemView(selected: self.$selectedIndex,
                              index: index,
                              item: items[index])
        }
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<items.count) { index in
                self.itemView(at: index)
                
                if index != self.items.count-1 {
                    Spacer()
                }
            }
        }
        .padding()
        .animation(Animation.easeInOut(duration: 0.2))
    }
}

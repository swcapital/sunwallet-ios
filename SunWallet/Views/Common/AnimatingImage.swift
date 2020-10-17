import SwiftUI

struct AnimatingImage: View {
    let images: [Image]
    
    init(images: [Image], interval: Double) {
        self.images = images
        self.counter = Counter(interval: interval)
    }
    
    @ObservedObject private var counter: Counter
            
    var body: some View {
        images[counter.value % images.count]
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

private class Counter: ObservableObject {
    private var timer: Timer?
    
    @Published var value: Int = 0
        
    init(interval: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in self.value += 1 }
    }
}

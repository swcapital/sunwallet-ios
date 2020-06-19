import SwiftUI

struct MarketStat: Identifiable {
    let id = UUID()
    
    let imageName: String
    let title: String
    let value: Text
    let description: String
    
    init(imageName: String, title: String, value: String, description: String) {
        self.imageName = imageName
        self.title = title
        self.value = Text(value).foregroundColor(.blueGray)
        self.description = description
    }
    
    init(imageName: String, title: String, value: Text, description: String) {
        self.imageName = imageName
        self.title = title
        self.value = value
        self.description = description
    }
}

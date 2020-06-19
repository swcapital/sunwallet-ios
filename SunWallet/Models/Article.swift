import Foundation

struct Article: Identifiable {
    let id = UUID()
    
    let title: String
    let text: String
    let imageName: String?
    let source: String
    let date: String
    let tag: String?
}

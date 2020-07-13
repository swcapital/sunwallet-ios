import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

struct MasterKey: Codable {
    let id: UUID
    let mnemonic: String
    let title: String
    let assets: [Asset]
    
    init(mnemonic: String, assets: [Asset]) {
        self.id = UUID()
        self.mnemonic = mnemonic
        let date = dateFormatter.string(from: Date())
        self.title = "Created at: \(date)"
        self.assets = assets
    }
}

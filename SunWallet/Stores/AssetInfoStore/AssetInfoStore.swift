import Foundation

class AssetInfoStore: ObservableObject {
    private lazy var assets: [AssetInfo] = bundleData()
    
    func info(for asset: Asset) -> AssetInfo? {
        assets.first(where: { $0.asset == asset })
    }
    
    private func bundleData() -> [AssetInfo] {
        let url = Bundle.main.url(forResource: "assets", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return (try? JSONDecoder().decode([AssetInfo].self, from: data)) ?? []
    }
}

import Foundation

struct TestData {
    static let dataSource = DataSource()
    static var randomAsset: Asset2 { dataSource.assets.randomElement()! }
    
    static let longText = """
    Commodi et fugit facere velit ea quam corporis sunt. Ut minus rerum consectetur hic rerum quo. Nihil porro qui ullam accusantium nisi dolorum autem. Facilis expedita eveniet repellat delectus. Harum quae assumenda repudiandae quos voluptatem quo placeat.
    """
}

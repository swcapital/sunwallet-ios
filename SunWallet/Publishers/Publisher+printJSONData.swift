import Combine
import Foundation

extension Publisher where Self.Output == Data  {
    
    func printJSONData() -> AnyPublisher<Self.Output, Self.Failure> {
        map { data in
            Swift.print(String(data: data, encoding: .utf8) ?? "Error")
            return data
        }
        .eraseToAnyPublisher()
    }
}

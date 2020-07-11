import Combine
import Foundation

extension URLSession.DataTaskPublisher {
    
    func extractData() -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                String(data: output.data, encoding: .utf8).map { Swift.print($0) }
                throw HTTPError.networkError
            }
            return output.data
        }
    }
}

enum HTTPError: LocalizedError {
    case networkError
    
    var errorDescription: String? { "Network error" }
}

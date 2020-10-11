import Combine
import Foundation

extension URLSession.DataTaskPublisher {
    
    func extractData() -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                String(data: output.data, encoding: .utf8).map { Swift.print($0) }
                Swift.print(output.response)
                throw HTTPError.response(output.data)
            }
            return output.data
        }
    }
}

enum HTTPError: Error {
    case response(Data)
    
    var data: Data {
        switch self {
        case .response(let data): return data
        }
    }
}

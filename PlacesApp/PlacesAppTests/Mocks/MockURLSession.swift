import Foundation
@testable import PlacesApp

final class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            throw NetworkError.invalidResponse
        }
        
        return (data, response)
    }
}
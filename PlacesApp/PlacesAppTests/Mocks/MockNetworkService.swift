import Foundation
@testable import PlacesApp

final class MockNetworkService: PlacesNetworkServiceProtocol {
    var places: [Place] = []
    var shouldThrowError = false
    var error: Error?
    
    func fetchLocations() async throws -> [Place] {
        if shouldThrowError {
            throw error ?? NetworkError.invalidURL
        }
        return places
    }
}
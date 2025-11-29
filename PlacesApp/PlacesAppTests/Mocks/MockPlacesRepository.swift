import Foundation
@testable import PlacesApp

final class MockPlacesRepositoryForUseCase: PlacesRepositoryProtocol {
    var places: [Place] = []
    var shouldThrowError = false
    var error: Error?
    
    func getLocations() async throws -> [Place] {
        if shouldThrowError {
            throw error ?? NetworkError.invalidURL
        }
        return places
    }
}

final class MockPlacesRepositoryForViewModel: PlacesRepositoryProtocol {
    var places: [Place] = []
    var shouldThrowError = false
    var error: Error?
    var delay: TimeInterval = 0
    
    func getLocations() async throws -> [Place] {
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        if shouldThrowError {
            throw error ?? NetworkError.invalidURL
        }
        
        return places
    }
}
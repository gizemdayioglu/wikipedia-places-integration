import XCTest
@testable import PlacesApp

final class GetLocationsUseCaseTests: XCTestCase {
    var useCase: GetLocationsUseCase!
    var mockRepository: MockPlacesRepositoryForUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPlacesRepositoryForUseCase()
        useCase = GetLocationsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        // Given
        let expectedPlaces = [
            Place(id: "1", name: "Place 1", latitude: 52.3676, longitude: 4.9041, description: "Description 1"),
            Place(id: "2", name: "Place 2", latitude: 51.5074, longitude: -0.1278, description: "Description 2")
        ]
        mockRepository.places = expectedPlaces
        
        // When
        let result = try await useCase.execute()
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.displayName, "Place 1")
        XCTAssertEqual(result.last?.displayName, "Place 2")
    }
    
    func testExecute_Error() async {
        // Given
        mockRepository.shouldThrowError = true
        mockRepository.error = NetworkError.invalidURL
        
        // When/Then
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}

// MARK: - Mock Repository for Use Case Tests
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


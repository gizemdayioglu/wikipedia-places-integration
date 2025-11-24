import XCTest
@testable import PlacesApp

final class PlacesRepositoryTests: XCTestCase {
    var repository: PlacesRepository!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = PlacesRepository(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testGetLocations_Success() async throws {
        let expectedPlaces = [
            Place(id: "1", name: "Test", latitude: 52.3676, longitude: 4.9041)
        ]
        mockNetworkService.places = expectedPlaces
        
        let result = try await repository.getLocations()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Test")
    }
    
    func testGetLocations_NetworkError() async {
        mockNetworkService.shouldThrowError = true
        mockNetworkService.error = NetworkError.invalidURL
        
        do {
            _ = try await repository.getLocations()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}

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


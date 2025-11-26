import XCTest
@testable import PlacesApp

@MainActor
final class PlacesViewModelTests: XCTestCase {
    var viewModel: PlacesViewModel!
    var mockRepository: MockPlacesRepositoryForViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPlacesRepositoryForViewModel()
        let useCase = GetLocationsUseCase(repository: mockRepository)
        viewModel = PlacesViewModel(getLocationsUseCase: useCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testLoadPlaces_Success() async {
        // Given
        let expectedPlaces = [
            Place(id: "1", name: "Test Place", latitude: 52.3676, longitude: 4.9041, description: "Test description")
        ]
        mockRepository.places = expectedPlaces
        
        // When
        await viewModel.loadPlaces()
        
        // Then
        XCTAssertEqual(viewModel.places.count, 1)
        XCTAssertEqual(viewModel.places.first?.name, "Test Place")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadPlaces_Error() async {
        // Given
        mockRepository.shouldThrowError = true
        mockRepository.error = NetworkError.invalidURL
        
        // When
        await viewModel.loadPlaces()
        
        // Then
        XCTAssertTrue(viewModel.places.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testOpenWikipediaWithCustomLocation_ValidCoordinates() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "4.9041"
        
        // When
        let url = viewModel.openWikipediaWithCustomLocation()
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "wikipedia")
        XCTAssertEqual(url?.host, "places")
    }
    
    func testOpenWikipediaWithCustomLocation_InvalidLatitude() {
        // Given
        viewModel.customLatitude = "100" // Invalid latitude
        viewModel.customLongitude = "4.9041"
        
        // When
        let url = viewModel.openWikipediaWithCustomLocation()
        
        // Then
        XCTAssertNil(url)
    }
    
    func testOpenWikipediaWithCustomLocation_InvalidLongitude() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "200" // Invalid longitude
        
        // When
        let url = viewModel.openWikipediaWithCustomLocation()
        
        // Then
        XCTAssertNil(url)
    }
    
    func testIsCustomLocationValid_ValidCoordinates() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "4.9041"
        
        // Then
        XCTAssertTrue(viewModel.isCustomLocationValid)
    }
    
    func testIsCustomLocationValid_InvalidCoordinates() {
        // Given
        viewModel.customLatitude = "invalid"
        viewModel.customLongitude = "4.9041"
        
        // Then
        XCTAssertFalse(viewModel.isCustomLocationValid)
    }
    
    func testIsCustomLocationValid_OutOfRangeLatitude() {
        viewModel.customLatitude = "91"
        viewModel.customLongitude = "4.9041"
        XCTAssertFalse(viewModel.isCustomLocationValid)
    }
    
    func testIsCustomLocationValid_OutOfRangeLongitude() {
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "181"
        XCTAssertFalse(viewModel.isCustomLocationValid)
    }
    
    func testIsCustomLocationValid_BoundaryValues() {
        viewModel.customLatitude = "90"
        viewModel.customLongitude = "180"
        XCTAssertTrue(viewModel.isCustomLocationValid)
        
        viewModel.customLatitude = "-90"
        viewModel.customLongitude = "-180"
        XCTAssertTrue(viewModel.isCustomLocationValid)
    }
    
    func testLoadPlaces_SetsLoadingState() async {
        mockRepository.delay = 0.1
        let places = [
            Place(id: "1", name: "Test", latitude: 52.3676, longitude: 4.9041)
        ]
        mockRepository.places = places
        
        let expectation = expectation(description: "Loading state")
        
        Task {
            await viewModel.loadPlaces()
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testOpenWikipediaWithCustomLocation_EmptyStrings() {
        viewModel.customLatitude = ""
        viewModel.customLongitude = ""
        
        let url = viewModel.openWikipediaWithCustomLocation()
        XCTAssertNil(url)
    }
    
    func testOpenWikipediaWithCustomLocation_NonNumeric() {
        viewModel.customLatitude = "abc"
        viewModel.customLongitude = "def"
        
        let url = viewModel.openWikipediaWithCustomLocation()
        XCTAssertNil(url)
    }
    
    // MARK: - Custom Location Tests
    
    func testCreateCustomLocation_ValidCoordinates() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "4.9041"
        
        // When
        let location = viewModel.createCustomLocation()
        
        // Then
        XCTAssertNotNil(location)
        XCTAssertEqual(location?.name, "Custom Location")
        XCTAssertEqual(location?.latitude, 52.3676)
        XCTAssertEqual(location?.longitude, 4.9041)
        XCTAssertEqual(location?.description, "Custom coordinates")
        XCTAssertTrue(location?.id.contains("52.3676") ?? false)
        XCTAssertTrue(location?.id.contains("4.9041") ?? false)
    }
    
    func testCreateCustomLocation_InvalidCoordinates() {
        // Given
        viewModel.customLatitude = "100"
        viewModel.customLongitude = "4.9041"
        
        // When
        let location = viewModel.createCustomLocation()
        
        // Then
        XCTAssertNil(location)
    }
    
    func testCreateCustomLocation_NonNumeric() {
        // Given
        viewModel.customLatitude = "abc"
        viewModel.customLongitude = "def"
        
        // When
        let location = viewModel.createCustomLocation()
        
        // Then
        XCTAssertNil(location)
    }
    
    func testShowCustomLocationOnMap_ValidCoordinates() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "4.9041"
        
        // When
        viewModel.showCustomLocationOnMap()
        
        // Then
        XCTAssertNotNil(viewModel.customLocation)
        XCTAssertEqual(viewModel.customLocation?.latitude, 52.3676)
        XCTAssertEqual(viewModel.customLocation?.longitude, 4.9041)
        XCTAssertTrue(viewModel.shouldShowCustomLocationOnMap)
    }
    
    func testShowCustomLocationOnMap_InvalidCoordinates() {
        // Given
        viewModel.customLatitude = "100"
        viewModel.customLongitude = "4.9041"
        
        // When
        viewModel.showCustomLocationOnMap()
        
        // Then
        XCTAssertNil(viewModel.customLocation)
        XCTAssertFalse(viewModel.shouldShowCustomLocationOnMap)
    }
    
    func testClearCustomLocation() {
        // Given
        viewModel.customLatitude = "52.3676"
        viewModel.customLongitude = "4.9041"
        viewModel.showCustomLocationOnMap()
        XCTAssertNotNil(viewModel.customLocation)
        XCTAssertTrue(viewModel.shouldShowCustomLocationOnMap)
        
        // When
        viewModel.clearCustomLocation()
        
        // Then
        XCTAssertNil(viewModel.customLocation)
        XCTAssertFalse(viewModel.shouldShowCustomLocationOnMap)
    }
    
    func testAllPlaces_WithoutCustomLocation() async {
        // Given
        let expectedPlaces = [
            Place(id: "1", name: "Place 1", latitude: 52.3676, longitude: 4.9041),
            Place(id: "2", name: "Place 2", latitude: 51.5074, longitude: -0.1278)
        ]
        mockRepository.places = expectedPlaces
        
        // When
        await viewModel.loadPlaces()
        
        // Then
        XCTAssertEqual(viewModel.allPlaces.count, 2)
        XCTAssertEqual(viewModel.allPlaces, expectedPlaces)
    }
    
    func testAllPlaces_WithCustomLocation() async {
        // Given
        let expectedPlaces = [
            Place(id: "1", name: "Place 1", latitude: 52.3676, longitude: 4.9041)
        ]
        mockRepository.places = expectedPlaces
        await viewModel.loadPlaces()
        
        viewModel.customLatitude = "40.7128"
        viewModel.customLongitude = "-74.0060"
        
        // When
        viewModel.showCustomLocationOnMap()
        
        // Then
        XCTAssertEqual(viewModel.allPlaces.count, 2)
        XCTAssertEqual(viewModel.allPlaces.first?.name, "Place 1")
        XCTAssertEqual(viewModel.allPlaces.last?.name, "Custom Location")
        XCTAssertEqual(viewModel.allPlaces.last?.latitude, 40.7128)
    }
    
    func testAllPlaces_CustomLocationIsLast() async {
        // Given
        let expectedPlaces = [
            Place(id: "1", name: "Place 1", latitude: 52.3676, longitude: 4.9041),
            Place(id: "2", name: "Place 2", latitude: 51.5074, longitude: -0.1278)
        ]
        mockRepository.places = expectedPlaces
        await viewModel.loadPlaces()
        
        viewModel.customLatitude = "40.7128"
        viewModel.customLongitude = "-74.0060"
        viewModel.showCustomLocationOnMap()
        
        // Then
        let allPlaces = viewModel.allPlaces
        XCTAssertEqual(allPlaces.count, 3)
        XCTAssertEqual(allPlaces.last?.name, "Custom Location")
    }
}

// MARK: - Mock Repository for ViewModel Tests
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


import XCTest
@testable import PlacesApp

final class PlaceAccessibilityTests: XCTestCase {
    
    func testPlace_AccessibilityText_WithName() {
        let place = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Capital of Netherlands"
        )
        
        let view = PlaceRowView(place: place)
        let accessibilityLabel = view.rowAccessibilityLabel
        let accessibilityValue = view.rowAccessibilityValue
        
        XCTAssertTrue(accessibilityLabel.contains("Amsterdam"))
        XCTAssertTrue(accessibilityValue.contains("Capital of Netherlands"))
        XCTAssertTrue(accessibilityValue.contains("Latitude"))
        XCTAssertTrue(accessibilityValue.contains("Longitude"))
        XCTAssertTrue(accessibilityValue.contains("52.37"))
        XCTAssertTrue(accessibilityValue.contains("4.90"))
    }
    
    func testPlace_AccessibilityText_WithoutName() {
        let place = Place(
            id: "2",
            name: nil,
            latitude: 40.4380638,
            longitude: -3.7495758
        )
        
        let view = PlaceRowView(place: place)
        let accessibilityValue = view.rowAccessibilityValue
        
        XCTAssertTrue(accessibilityValue.contains("40.44"))
        XCTAssertTrue(accessibilityValue.contains("-3.75"))
        XCTAssertTrue(accessibilityValue.contains("Latitude"))
        XCTAssertTrue(accessibilityValue.contains("Longitude"))
    }
    
    func testPlace_AccessibilityText_WithoutDescription() {
        let place = Place(
            id: "3",
            name: "London",
            latitude: 51.5074,
            longitude: -0.1278,
            description: nil
        )
        
        let view = PlaceRowView(place: place)
        let accessibilityLabel = view.rowAccessibilityLabel
        let accessibilityValue = view.rowAccessibilityValue
        
        XCTAssertTrue(accessibilityLabel.contains("London"))
        XCTAssertTrue(accessibilityValue.contains("Latitude"))
        XCTAssertTrue(accessibilityValue.contains("Longitude"))
    }
    
    func testPlace_DisplayName_Accessibility() {
        let placeWithName = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        XCTAssertEqual(placeWithName.displayName, "Amsterdam")
        
        let placeWithoutName = Place(
            id: "2",
            name: nil,
            latitude: 40.4380638,
            longitude: -3.7495758
        )
        XCTAssertTrue(placeWithoutName.displayName.contains("40.44"))
        XCTAssertTrue(placeWithoutName.displayName.contains("-3.75"))
    }
    
    func testPlace_WikipediaDeepLinkURL_Accessibility() {
        let place = Place(
            id: "1",
            name: "Test",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        let url = place.wikipediaDeepLinkURL
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "wikipedia")
        XCTAssertEqual(url?.host, "places")
    }
    
    @MainActor
    func testPlacesViewModel_IsCustomLocationValid_EdgeCases() {
        let viewModel = PlacesViewModel(getLocationsUseCase: GetLocationsUseCase(repository: MockPlacesRepositoryForViewModel()))
        
        viewModel.customLatitude = "90"
        viewModel.customLongitude = "180"
        XCTAssertTrue(viewModel.isCustomLocationValid)
        
        viewModel.customLatitude = "-90"
        viewModel.customLongitude = "-180"
        XCTAssertTrue(viewModel.isCustomLocationValid)
        
        viewModel.customLatitude = "0"
        viewModel.customLongitude = "0"
        XCTAssertTrue(viewModel.isCustomLocationValid)
    }
    
    func testPlace_AccessibilityText_Format() {
        let place = Place(
            id: "1",
            name: "Test",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Description"
        )
        
        let view = PlaceRowView(place: place)
        let text = view.rowAccessibilityValue
        
        XCTAssertTrue(text.contains("Description"))
        XCTAssertTrue(text.contains("Latitude 52.37"))
        XCTAssertTrue(text.contains("Longitude 4.90"))
    }
}

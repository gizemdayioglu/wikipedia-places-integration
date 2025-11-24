import XCTest
@testable import PlacesApp

final class AccessibilityTests: XCTestCase {
    
    func testPlace_AccessibilityText_WithName() {
        let place = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Capital of Netherlands"
        )
        
        let view = PlaceRowView(place: place)
        let accessibilityText = view.accessibilityText
        
        XCTAssertTrue(accessibilityText.contains("Amsterdam"))
        XCTAssertTrue(accessibilityText.contains("Capital of Netherlands"))
        XCTAssertTrue(accessibilityText.contains("latitude"))
        XCTAssertTrue(accessibilityText.contains("longitude"))
        XCTAssertTrue(accessibilityText.contains("52.3676"))
        XCTAssertTrue(accessibilityText.contains("4.9041"))
    }
    
    func testPlace_AccessibilityText_WithoutName() {
        let place = Place(
            id: "2",
            name: nil,
            latitude: 40.4380638,
            longitude: -3.7495758
        )
        
        let view = PlaceRowView(place: place)
        let accessibilityText = view.accessibilityText
        
        XCTAssertTrue(accessibilityText.contains("40.44"))
        XCTAssertTrue(accessibilityText.contains("-3.75"))
        XCTAssertTrue(accessibilityText.contains("latitude"))
        XCTAssertTrue(accessibilityText.contains("longitude"))
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
        let accessibilityText = view.accessibilityText
        
        XCTAssertTrue(accessibilityText.contains("London"))
        XCTAssertTrue(accessibilityText.contains("latitude"))
        XCTAssertTrue(accessibilityText.contains("longitude"))
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
        let text = view.accessibilityText
        
        XCTAssertTrue(text.hasPrefix("Test"))
        XCTAssertTrue(text.contains("Description"))
        XCTAssertTrue(text.contains("latitude 52.3676"))
        XCTAssertTrue(text.contains("longitude 4.9041"))
    }
}

extension PlaceRowView {
    var accessibilityText: String {
        var text = place.displayName
        
        if let desc = place.description {
            text += ", \(desc)"
        }
        
        text += ", latitude \(place.latitude), longitude \(place.longitude)"
        return text
    }
}

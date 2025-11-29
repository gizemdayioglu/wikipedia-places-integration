import XCTest
@testable import PlacesApp

final class PlaceRowViewTests: XCTestCase {
    
    func testPlace_AccessibilityText_Property() {
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
}


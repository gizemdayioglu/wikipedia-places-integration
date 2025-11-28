import XCTest
import CoreLocation
@testable import PlacesApp

final class PlaceModelTests: XCTestCase {
    func testPlaceInitialization() {
        // Given/When
        let place = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Capital of Netherlands"
        )
        
        // Then
        XCTAssertEqual(place.id, "1")
        XCTAssertEqual(place.name, "Amsterdam")
        XCTAssertEqual(place.latitude, 52.3676, accuracy: 0.0001)
        XCTAssertEqual(place.longitude, 4.9041, accuracy: 0.0001)
        XCTAssertEqual(place.description, "Capital of Netherlands")
        XCTAssertEqual(place.displayName, "Amsterdam")
    }
    
    func testPlaceCoordinate() {
        // Given
        let place = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        // When
        let coordinate = place.coordinate
        
        // Then
        XCTAssertEqual(coordinate.latitude, 52.3676, accuracy: 0.0001)
        XCTAssertEqual(coordinate.longitude, 4.9041, accuracy: 0.0001)
    }
    
    func testPlaceWikipediaDeepLinkURL() {
        // Given
        let place = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        // When
        let url = place.wikipediaDeepLinkURL
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "wikipedia")
        XCTAssertEqual(url?.host, "places")
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        let latItem = queryItems?.first { $0.name == "lat" }
        let lonItem = queryItems?.first { $0.name == "lon" }
        
        XCTAssertEqual(latItem?.value, "52.3676")
        XCTAssertEqual(lonItem?.value, "4.9041")
    }
    
    func testPlaceEquatable() {
        // Given
        let place1 = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Description"
        )
        
        let place2 = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041,
            description: "Description"
        )
        
        let place3 = Place(
            id: "2",
            name: "London",
            latitude: 51.5074,
            longitude: -0.1278,
            description: "Description"
        )
        
        // Then
        XCTAssertEqual(place1, place2)
        XCTAssertNotEqual(place1, place3)
    }
    
    func testPlaceDisplayName() {
        // Given - place with name
        let placeWithName = Place(
            id: "1",
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        // Then
        XCTAssertEqual(placeWithName.displayName, "Amsterdam")
        
        // Given - place without name
        let placeWithoutName = Place(
            id: "2",
            name: nil,
            latitude: 40.4380638,
            longitude: -3.7495758
        )
        
        // Then
        XCTAssertTrue(placeWithoutName.displayName.contains("40.44"))
        XCTAssertTrue(placeWithoutName.displayName.contains("-3.75"))
    }
    
    func testPlaceDecoding_GeneratesID() throws {
        let json = """
        {
            "name": "Test",
            "lat": 52.3676,
            "long": 4.9041
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let place = try decoder.decode(Place.self, from: json)
        
        XCTAssertNotNil(place.id)
        XCTAssertTrue(place.id.contains("52.3676"))
        XCTAssertTrue(place.id.contains("4.9041"))
    }
    
    func testPlaceDecoding_MissingLatitude() {
        let json = """
        {
            "name": "Test",
            "long": 4.9041
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(Place.self, from: json))
    }
    
    func testPlaceDecoding_MissingLongitude() {
        let json = """
        {
            "name": "Test",
            "lat": 52.3676
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(Place.self, from: json))
    }
}


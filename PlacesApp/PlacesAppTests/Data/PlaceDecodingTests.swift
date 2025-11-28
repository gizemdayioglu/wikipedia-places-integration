import XCTest
@testable import PlacesApp

final class PlaceDecodingTests: XCTestCase {
    func testDecodePlace_WithName() throws {
        let json = """
        {
            "name": "Amsterdam",
            "lat": 52.3676,
            "long": 4.9041
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let place = try decoder.decode(Place.self, from: json)
        
        XCTAssertEqual(place.name, "Amsterdam")
        XCTAssertEqual(place.latitude, 52.3676, accuracy: 0.0001)
        XCTAssertEqual(place.longitude, 4.9041, accuracy: 0.0001)
        XCTAssertNotNil(place.id)
    }
    
    func testDecodePlace_WithoutName() throws {
        let json = """
        {
            "lat": 40.4380638,
            "long": -3.7495758
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let place = try decoder.decode(Place.self, from: json)
        
        XCTAssertNil(place.name)
        XCTAssertEqual(place.latitude, 40.4380638, accuracy: 0.0001)
        XCTAssertEqual(place.longitude, -3.7495758, accuracy: 0.0001)
    }
    
    func testDecodePlacesResponse() throws {
        let json = """
        {
            "locations": [
                {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041},
                {"lat": 40.4380638, "long": -3.7495758}
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(PlacesResponse.self, from: json)
        
        XCTAssertEqual(response.locations.count, 2)
        XCTAssertEqual(response.locations.first?.name, "Amsterdam")
        XCTAssertNil(response.locations.last?.name)
    }
}


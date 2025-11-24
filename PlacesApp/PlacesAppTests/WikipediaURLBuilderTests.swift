import XCTest
@testable import PlacesApp

final class WikipediaURLBuilderTests: XCTestCase {
    func testMakePlacesURL_ValidCoordinates() {
        let url = WikipediaURLBuilder.makePlacesURL(lat: 52.3676, lon: 4.9041)
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "wikipedia")
        XCTAssertEqual(url?.host, "places")
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let latItem = components?.queryItems?.first { $0.name == "lat" }
        let lonItem = components?.queryItems?.first { $0.name == "lon" }
        
        XCTAssertEqual(latItem?.value, "52.3676")
        XCTAssertEqual(lonItem?.value, "4.9041")
    }
    
    func testMakePlacesURL_InvalidLatitude_TooHigh() {
        let url = WikipediaURLBuilder.makePlacesURL(lat: 91, lon: 4.9041)
        XCTAssertNil(url)
    }
    
    func testMakePlacesURL_InvalidLatitude_TooLow() {
        let url = WikipediaURLBuilder.makePlacesURL(lat: -91, lon: 4.9041)
        XCTAssertNil(url)
    }
    
    func testMakePlacesURL_InvalidLongitude_TooHigh() {
        let url = WikipediaURLBuilder.makePlacesURL(lat: 52.3676, lon: 181)
        XCTAssertNil(url)
    }
    
    func testMakePlacesURL_InvalidLongitude_TooLow() {
        let url = WikipediaURLBuilder.makePlacesURL(lat: 52.3676, lon: -181)
        XCTAssertNil(url)
    }
    
    func testMakePlacesURL_BoundaryValues() {
        let url1 = WikipediaURLBuilder.makePlacesURL(lat: 90, lon: 180)
        XCTAssertNotNil(url1)
        
        let url2 = WikipediaURLBuilder.makePlacesURL(lat: -90, lon: -180)
        XCTAssertNotNil(url2)
        
        let url3 = WikipediaURLBuilder.makePlacesURL(lat: 0, lon: 0)
        XCTAssertNotNil(url3)
    }
}


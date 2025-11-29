import XCTest
@testable import PlacesApp

final class PlacesNetworkServiceTests: XCTestCase {
    var service: PlacesNetworkService!
    var mockURLSession: MockURLSession!
    var mockReachability: MockNetworkReachability!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockReachability = MockNetworkReachability(isConnected: true)
        service = PlacesNetworkService(
            baseURL: "https://example.com/locations.json",
            urlSession: mockURLSession,
            reachability: mockReachability
        )
    }
    
    override func tearDown() {
        service = nil
        mockURLSession = nil
        mockReachability = nil
        super.tearDown()
    }
    
    func testFetchLocations_Success() async throws {
        let jsonData = """
        {
            "locations": [
                {"name": "Amsterdam", "lat": 52.3676, "long": 4.9041}
            ]
        }
        """.data(using: .utf8)!
        
        mockURLSession.data = jsonData
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result = try await service.fetchLocations()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Amsterdam")
    }
    
    func testFetchLocations_InvalidResponse() async {
        mockURLSession.data = Data()
        mockURLSession.response = URLResponse()
        
        do {
            _ = try await service.fetchLocations()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testFetchLocations_HTTPError() async {
        mockURLSession.data = Data()
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await service.fetchLocations()
            XCTFail("Expected error")
        } catch {
            if case NetworkError.httpError(let code) = error {
                XCTAssertEqual(code, 404)
            } else {
                XCTFail("Expected httpError")
            }
        }
    }
    
    func testFetchLocations_DecodingError() async {
        let invalidData = "invalid json".data(using: .utf8)!
        mockURLSession.data = invalidData
        mockURLSession.response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await service.fetchLocations()
            XCTFail("Expected error")
        } catch {
            if case NetworkError.decodingError(let underlyingError) = error {
                XCTAssertNotNil(underlyingError)
            } else {
                XCTFail("Expected decodingError")
            }
        }
    }
}


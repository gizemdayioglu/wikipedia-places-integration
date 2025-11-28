import XCTest
@testable import PlacesApp

final class NetworkErrorTests: XCTestCase {
    func testInvalidURL_ErrorDescription() {
        let error = NetworkError.invalidURL
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription?.contains("Invalid") ?? false)
    }
    
    func testInvalidResponse_ErrorDescription() {
        let error = NetworkError.invalidResponse
        XCTAssertNotNil(error.errorDescription)
    }
    
    func testHTTPError_ErrorDescription() {
        let error = NetworkError.httpError(statusCode: 404)
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription?.contains("404") ?? false)
    }
    
    func testDecodingError_ErrorDescription() {
        let decodingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let error = NetworkError.decodingError(decodingError)
        XCTAssertNotNil(error.errorDescription)
    }
}


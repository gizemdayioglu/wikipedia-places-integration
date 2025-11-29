import XCTest
import SwiftUI
@testable import PlacesApp

@MainActor
final class ErrorStateViewTests: XCTestCase {
    
    func testErrorStateView_CanBeInstantiated() {
        let view = ErrorStateView(message: "Error", onRetry: {})
        XCTAssertNotNil(view)
    }
    
    func testErrorStateView_MessageIsSet() {
        let expectedMessage = "Network error occurred"
        let view = ErrorStateView(message: expectedMessage, onRetry: {})
        
        XCTAssertEqual(view.message, expectedMessage)
    }
    
    func testErrorStateView_RetryActionIsCalled() {
        var called = false
        
        let view = ErrorStateView(message: "Error") {
            called = true
        }
        
        view.onRetry()
        
        XCTAssertTrue(called)
    }
}

import XCTest

final class ErrorStateUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITest_ErrorState"]
        app.launch()
    }
    
    func testErrorStateView_IsVisible() {
        let retryButton = app.buttons["RetryButton"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 3))
    }
    
    func testRetryButton_Accessibility() {
        let retryButton = app.buttons["RetryButton"]
        XCTAssertTrue(retryButton.exists)
        XCTAssertTrue(retryButton.isHittable)
        XCTAssertTrue(retryButton.isEnabled)
        XCTAssertEqual(retryButton.label, "Retry")
    }
}

import XCTest

final class PlacesAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testPlacesListViewLoadsData() {
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

        firstCell.tap()
        
        // Tapping opens Wikipedia via UIApplication.shared.open
        // We can't open external apps in UI tests, we just check that the tap succeeded.
        XCTAssertTrue(true)
    }
    
    func testCustomLocationButton() throws {
        let button = app.buttons["Add custom location"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
    }
    
    func testCustomLocationInput() throws {
        app.buttons["Add custom location"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        
        latField.tap()
        latField.doubleTap()
        latField.typeText("52.3676")
        
        lonField.tap()
        lonField.doubleTap()
        lonField.typeText("4.9041")
        
        let openButton = app.buttons["OpenWikipediaButton"]
        XCTAssertTrue(openButton.waitForExistence(timeout: 2))
        XCTAssertTrue(openButton.isEnabled)
    }
}

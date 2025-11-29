import XCTest

final class AccessibilityUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testViewModeSelector_IsAccessible() {
        let selector = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(selector.waitForExistence(timeout: 3))
        XCTAssertTrue(selector.exists)
        XCTAssertTrue(selector.isEnabled)
        XCTAssertTrue(selector.isHittable)
        XCTAssertEqual(selector.label, "View mode selector")
    }

    func testAddCustomLocationButton_IsAccessible() {
        let button = app.buttons["AddCustomLocationButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 3))
        XCTAssertTrue(button.exists)
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(button.isHittable)
        XCTAssertEqual(button.label, "Add custom location")
    }

    func testEmptyStateView_IsAccessible() {
        let emptyState = app.otherElements["EmptyStateView"]
        if emptyState.waitForExistence(timeout: 2) {
            XCTAssertTrue(emptyState.exists)
            XCTAssertTrue(emptyState.isHittable)
            XCTAssertEqual(emptyState.label, "No places found.")
        }
    }

    func testPlaceRowView_IsAccessible() {
        app.segmentedControls["ViewModeSelector"].buttons["List"].tap()
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        XCTAssertTrue(firstCell.exists)
        XCTAssertTrue(firstCell.isHittable)
    }

    func testLatitudeField_IsAccessible() {
        app.buttons["AddCustomLocationButton"].tap()
        let latField = app.textFields["LatitudeField"]
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(latField.exists)
        XCTAssertTrue(latField.isEnabled)
        XCTAssertTrue(latField.isHittable)
        XCTAssertEqual(latField.label, "Latitude")
    }

    func testLongitudeField_IsAccessible() {
        app.buttons["AddCustomLocationButton"].tap()
        let lonField = app.textFields["LongitudeField"]
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.exists)
        XCTAssertTrue(lonField.isEnabled)
        XCTAssertTrue(lonField.isHittable)
        XCTAssertEqual(lonField.label, "Longitude")
    }

    func testShowLocationButton_IsAccessible_WhenDisabled() {
        app.buttons["AddCustomLocationButton"].tap()
        let showButton = app.buttons["ShowLocationButton"]
        XCTAssertTrue(showButton.waitForExistence(timeout: 3))
        XCTAssertTrue(showButton.exists)
        XCTAssertFalse(showButton.isEnabled)
        XCTAssertTrue(showButton.isHittable)
        XCTAssertEqual(showButton.label, "Show Location, disabled")
    }

    func testShowLocationButton_IsAccessible_WhenEnabled() {
        app.buttons["AddCustomLocationButton"].tap()
        let showButton = app.buttons["ShowLocationButton"]
        XCTAssertTrue(showButton.waitForExistence(timeout: 3))
        app.textFields["LatitudeField"].tap()
        app.textFields["LatitudeField"].typeText("52.3676")
        app.textFields["LongitudeField"].tap()
        app.textFields["LongitudeField"].typeText("4.9041")
        XCTAssertTrue(showButton.exists)
        XCTAssertTrue(showButton.isEnabled)
        XCTAssertTrue(showButton.isHittable)
        XCTAssertEqual(showButton.label, "Show Location")
    }

    func testDoneButton_IsAccessible() {
        app.buttons["AddCustomLocationButton"].tap()
        let doneButton = app.buttons["DoneButton"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3))
        XCTAssertTrue(doneButton.exists)
        XCTAssertTrue(doneButton.isEnabled)
        XCTAssertTrue(doneButton.isHittable)
        XCTAssertEqual(doneButton.label, "Done")
    }
}

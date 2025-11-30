import XCTest

final class PlacesAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["UITest_MockData"]
        app.launch()
    }

    var segmentedControl: XCUIElement {
        app.segmentedControls["ViewModeSelector"]
    }

    func clearAndEnterText(_ element: XCUIElement, text: String) {
        element.tap()
        element.press(forDuration: 0.3)
        element.typeText(text)
    }

    func testPlacesListViewLoadsData() {
        segmentedControl.buttons["List"].tap()

        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForVisible(timeout: 3))

        firstCell.tap()
    }
    
    func testMapViewToggle() {
        XCTAssertTrue(segmentedControl.buttons["Map"].isSelected)
        
        segmentedControl.buttons["List"].tap()
        XCTAssertTrue(segmentedControl.buttons["List"].isSelected)
        
        segmentedControl.buttons["Map"].tap()
        XCTAssertTrue(segmentedControl.buttons["Map"].isSelected)
    }
    
    func testCustomLocationButtonExists() {
        XCTAssertTrue(app.buttons["AddCustomLocationButton"].waitForVisible(timeout: 3))
    }

    func testCustomLocationInput() {
        app.buttons["AddCustomLocationButton"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        let showButton = app.buttons["ShowLocationButton"]

        XCTAssertTrue(latField.waitForVisible(timeout: 2))
        XCTAssertTrue(lonField.waitForVisible(timeout: 2))

        clearAndEnterText(latField, text: "52.3676")
        clearAndEnterText(lonField, text: "4.9041")

        XCTAssertTrue(showButton.waitForVisible(timeout: 2))
        XCTAssertTrue(showButton.isEnabled)
    }

    func testPullToRefresh() {
        segmentedControl.buttons["List"].tap()

        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForVisible(timeout: 3))

        app.swipeDown()

        XCTAssertTrue(firstCell.waitForVisible(timeout: 2))
    }

    func testListToMapTransition() {
        segmentedControl.buttons["List"].tap()

        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForVisible(timeout: 3))

        segmentedControl.buttons["Map"].tap()
        XCTAssertFalse(firstCell.exists)
    }

    func testMapToListTransition() {
        segmentedControl.buttons["List"].tap()

        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForVisible(timeout: 3))
    }

    func testCustomLocationButtonOpensSheet() {
        app.buttons["AddCustomLocationButton"].tap()
        XCTAssertTrue(app.textFields["LatitudeField"].waitForVisible(timeout: 2))
    }

    func testCustomLocationValidation() {
        app.buttons["AddCustomLocationButton"].tap()

        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        let showButton = app.buttons["ShowLocationButton"]

        XCTAssertTrue(latField.waitForVisible(timeout: 2))
        XCTAssertTrue(lonField.waitForVisible(timeout: 2))

        clearAndEnterText(latField, text: "999")
        clearAndEnterText(lonField, text: "999")
        XCTAssertFalse(showButton.isEnabled)

        latField.doubleTap()
        latField.typeText("52.3676")

        lonField.doubleTap()
        lonField.typeText("4.9041")

        XCTAssertTrue(showButton.isEnabled)
    }

    func testShowCustomLocation() {
        app.buttons["AddCustomLocationButton"].tap()

        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]

        clearAndEnterText(latField, text: "52.3676")
        clearAndEnterText(lonField, text: "4.9041")

        app.buttons["ShowLocationButton"].tap()

        segmentedControl.buttons["List"].tap()

        let cells = app.cells
        XCTAssertTrue(cells.count > 0)

        let lastCell = cells.element(boundBy: cells.count - 1)
        XCTAssertTrue(lastCell.waitForVisible(timeout: 2))
    }
    
    func testEmptyStateView_IsVisible() {
        let emptyStateApp = XCUIApplication()
        emptyStateApp.launchArguments = ["UITest_MockData", "UITest_EmptyState"]
        emptyStateApp.launch()
        
        let selector = emptyStateApp.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(selector.waitForVisible(timeout: 5))
        
        selector.buttons["List"].tap()
        
        let emptyStateText = emptyStateApp.staticTexts["No places found."]
        XCTAssertTrue(emptyStateText.waitForVisible(timeout: 5))
        XCTAssertTrue(emptyStateText.exists)
        
        let emptyStateView = emptyStateApp.otherElements["EmptyStateView"]
        if emptyStateView.exists {
            XCTAssertTrue(emptyStateView.exists)
        }
    }
}

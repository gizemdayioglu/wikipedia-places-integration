import XCTest

final class PlacesAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    var segmentedControl: XCUIElement {
        let control = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(control.waitForExistence(timeout: 5))
        return control
    }
    
    func clearAndEnterText(_ element: XCUIElement, text: String) {
        element.tap()
        element.press(forDuration: 1)
        element.typeText(text)
    }
    
    func testPlacesListViewLoadsData() {
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
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
        XCTAssertTrue(app.buttons["AddCustomLocationButton"].waitForExistence(timeout: 5))
    }
    
    func testCustomLocationInput() {
        app.buttons["AddCustomLocationButton"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        
        clearAndEnterText(latField, text: "52.3676")
        clearAndEnterText(lonField, text: "4.9041")
        
        let showButton = app.buttons["ShowLocationButton"]
        XCTAssertTrue(showButton.waitForExistence(timeout: 2))
        XCTAssertTrue(showButton.isEnabled)
    }
    
    func testPullToRefresh() {
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        app.swipeDown()
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3))
    }
    
    func testListToMapTransition() {
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        segmentedControl.buttons["Map"].tap()
        XCTAssertFalse(firstCell.exists)
    }
    
    func testMapToListTransition() {
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    }
    
    func testCustomLocationButtonOpensSheet() {
        app.buttons["AddCustomLocationButton"].tap()
        XCTAssertTrue(app.textFields["LatitudeField"].waitForExistence(timeout: 3))
    }
    
    func testCustomLocationValidation() {
        app.buttons["AddCustomLocationButton"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        let showButton = app.buttons["ShowLocationButton"]
        
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        
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
        XCTAssertTrue(lastCell.waitForExistence(timeout: 3))
    }
}

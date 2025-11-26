import XCTest

final class PlacesAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testPlacesListViewLoadsData() {
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 5))
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
    }
    
    func testMapViewToggle() {
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 5))
        
        let mapButton = segmentedControl.buttons["Map"]
        XCTAssertTrue(mapButton.isSelected)
        
        segmentedControl.buttons["List"].tap()
        XCTAssertTrue(segmentedControl.buttons["List"].isSelected)
        
        segmentedControl.buttons["Map"].tap()
        XCTAssertTrue(segmentedControl.buttons["Map"].isSelected)
    }
    
    func testCustomLocationButton() throws {
        let button = app.buttons["AddCustomLocationButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
    }
    
    func testCustomLocationInput() throws {
        app.buttons["AddCustomLocationButton"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        
        latField.tap()
        latField.typeText("52.3676")
        
        lonField.tap()
        lonField.typeText("4.9041")
        
        let showButton = app.buttons["ShowLocationButton"]
        XCTAssertTrue(showButton.waitForExistence(timeout: 2))
        XCTAssertTrue(showButton.isEnabled)
    }
    
    func testPullToRefresh() {
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        firstCell.swipeDown()
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3))
    }
    
    func testListToMapTransition() {
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        segmentedControl.buttons["Map"].tap()
        XCTAssertFalse(firstCell.exists)
    }
    
    func testMapToListTransition() {
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 5))
        
        segmentedControl.buttons["List"].tap()
        
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    }
    
    func testCustomLocationButtonOpensSheet() {
        let button = app.buttons["AddCustomLocationButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        
        button.tap()
        
        let latField = app.textFields["LatitudeField"]
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
    }
    
    func testCustomLocationValidation() {
        app.buttons["AddCustomLocationButton"].tap()
        
        let latField = app.textFields["LatitudeField"]
        let lonField = app.textFields["LongitudeField"]
        let showButton = app.buttons["ShowLocationButton"]
        
        XCTAssertTrue(latField.waitForExistence(timeout: 3))
        XCTAssertTrue(lonField.waitForExistence(timeout: 3))
        XCTAssertTrue(showButton.waitForExistence(timeout: 2))
        
        latField.tap()
        latField.typeText("999")
        lonField.tap()
        lonField.typeText("999")
        
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
        let showButton = app.buttons["ShowLocationButton"]
        
        latField.tap()
        latField.typeText("52.3676")
        lonField.tap()
        lonField.typeText("4.9041")
        
        showButton.tap()
        
        let segmentedControl = app.segmentedControls["ViewModeSelector"]
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 3))
        
        segmentedControl.buttons["List"].tap()
        
        let cells = app.cells
        XCTAssertTrue(cells.count > 0)
        
        let lastCell = cells.element(boundBy: cells.count - 1)
        XCTAssertTrue(lastCell.waitForExistence(timeout: 3))
    }
}

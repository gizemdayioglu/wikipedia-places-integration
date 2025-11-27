import XCTest
@testable import PlacesApp

final class CreateCustomLocationUseCaseTests: XCTestCase {
    var useCase: CreateCustomLocationUseCase!
    
    override func setUp() {
        super.setUp()
        useCase = CreateCustomLocationUseCase()
    }
    
    override func tearDown() {
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_ValidCoordinates() {
        // Given
        let latString = "52.3676"
        let lonString = "4.9041"
        
        // When
        let result = useCase.execute(latString: latString, lonString: lonString)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "Custom Location")
        XCTAssertEqual(result?.latitude, 52.3676)
        XCTAssertEqual(result?.longitude, 4.9041)
        XCTAssertEqual(result?.description, "Custom coordinates")
        XCTAssertEqual(result?.id, "custom-52.3676,4.9041")
    }
    
    func testExecute_InvalidCoordinates() {
        // Given
        let latString = "100"
        let lonString = "4.9041"
        
        // When
        let result = useCase.execute(latString: latString, lonString: lonString)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testExecute_NonNumeric() {
        // Given
        let latString = "abc"
        let lonString = "def"
        
        // When
        let result = useCase.execute(latString: latString, lonString: lonString)
        
        // Then
        XCTAssertNil(result)
    }
}


import XCTest
@testable import PlacesApp

final class NetworkReachabilityTests: XCTestCase {
    
    func testIsConnected_DoesNotCrash() {
        let reachability = NetworkReachability()
        
        // Verify property is accessible and returns a boolean
        let isConnected = reachability.isConnected
        XCTAssertTrue(type(of: isConnected) == Bool.self)
    }
    
    func testNetworkReachabilityProtocol_CanBeInjected() {
        let sut: NetworkReachabilityProtocol = MockNetworkReachability(isConnected: false)
        
        XCTAssertFalse(sut.isConnected)
    }
    
    func testNetworkReachabilityProtocol_CanBeMocked() {
        let mock = MockNetworkReachability(isConnected: true)
        
        let isConnected = mock.isConnected
        
        XCTAssertTrue(isConnected)
    }
}
final class MockNetworkReachability: NetworkReachabilityProtocol {
    let isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}


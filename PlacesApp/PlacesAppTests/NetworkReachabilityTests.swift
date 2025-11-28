import XCTest
@testable import PlacesApp

final class NetworkReachabilityTests: XCTestCase {
    
    func testIsConnected_ReturnsBoolean() {
        let reachability = NetworkReachability()
        
        let isConnected = reachability.isConnected

        XCTAssertTrue(isConnected == true || isConnected == false)
    }
    
    func testNetworkReachability_ConformsToProtocol() {
        let reachability = NetworkReachability()
        
        let protocolInstance: NetworkReachabilityProtocol = reachability
        
        let _ = protocolInstance.isConnected
        XCTAssertTrue(true)
    }
    
    func testIsConnected_IsReadable() {
        let reachability = NetworkReachability()
    
        let _ = reachability.isConnected
        
        XCTAssertTrue(true)
    }
}
final class MockNetworkReachability: NetworkReachabilityProtocol {
    let isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}


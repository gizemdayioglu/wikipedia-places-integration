import Foundation
@testable import PlacesApp

final class MockNetworkReachability: NetworkReachabilityProtocol {
    let isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
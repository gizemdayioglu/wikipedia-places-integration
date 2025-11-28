import Foundation
import Network

protocol NetworkReachabilityProtocol {
    var isConnected: Bool { get }
}

final class NetworkReachability: NetworkReachabilityProtocol {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkReachabilityQueue")
    private(set) var isConnected: Bool
    
    init() {
        monitor = NWPathMonitor()
        
        isConnected = monitor.currentPath.status == .satisfied
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        
        monitor.start(queue: queue)
    }
}


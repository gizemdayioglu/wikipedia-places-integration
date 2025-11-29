import SwiftUI

@main
struct PlacesAppApp: App {
    private let container: DependencyContainerProtocol = {
        if ProcessInfo.processInfo.arguments.contains("UITest_MockData") {
            return TestDependencyContainer.shared
        }
        return DependencyContainer.shared
    }()
    
    var body: some Scene {
        WindowGroup {
            PlacesListView()
                .environmentObject(container.placesViewModel)
        }
    }
}


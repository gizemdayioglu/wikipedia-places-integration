import SwiftUI

@main
struct PlacesAppApp: App {
    private let container: DependencyContainerProtocol = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            PlacesListView()
                .environmentObject(container.placesViewModel)
        }
    }
}


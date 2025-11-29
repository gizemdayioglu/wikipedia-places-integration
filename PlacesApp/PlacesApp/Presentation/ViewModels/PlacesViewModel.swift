import Foundation
import SwiftUI

enum PlacesViewState {
    case loading
    case error(String)
    case empty
    case loaded
}

@MainActor
final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var state: PlacesViewState = .loading
    @Published var customLatitude: String = ""
    @Published var customLongitude: String = ""
    @Published var customLocation: Place?
    @Published var shouldShowCustomLocationOnMap = false
    
    private let getLocationsUseCase: GetLocationsUseCase
    private let createCustomLocationUseCase: CreateCustomLocationUseCase
    
    init(
        getLocationsUseCase: GetLocationsUseCase,
        createCustomLocationUseCase: CreateCustomLocationUseCase
    ) {
        self.getLocationsUseCase = getLocationsUseCase
        self.createCustomLocationUseCase = createCustomLocationUseCase
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        return nil
    }
    
    func loadPlaces() async {
        state = .loading
        
        do {
            let results = try await getLocationsUseCase.execute()
            self.places = results
            
            updateState()
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    private func updateState() {
        if allPlaces.isEmpty {
            state = .empty
        } else {
            state = .loaded
        }
    }
    
    private var parsedCoordinates: (lat: Double, lon: Double)? {
        CoordinateValidator.parseAndValidate(
            latString: customLatitude,
            lonString: customLongitude
        )
    }
    
    var isCustomLocationValid: Bool {
        return parsedCoordinates != nil
    }
    
    func createCustomLocation() -> Place? {
        return createCustomLocationUseCase.execute(
            latString: customLatitude,
            lonString: customLongitude
        )
    }
    
    func showCustomLocationOnMap() {
        guard let location = createCustomLocation() else { return }
        customLocation = location
        shouldShowCustomLocationOnMap = true
        updateState()
    }
    
    func clearCustomLocation() {
        customLocation = nil
        shouldShowCustomLocationOnMap = false
        customLatitude = ""
        customLongitude = ""
        updateState()
    }
    
    var allPlaces: [Place] {
        var result = places
        if let customLocation = customLocation {
            result.append(customLocation)
        }
        return result
    }
}

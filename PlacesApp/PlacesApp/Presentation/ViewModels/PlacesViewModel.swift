import Foundation
import SwiftUI

@MainActor
final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
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
    
    func loadPlaces() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await getLocationsUseCase.execute()
            self.places = results
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private var parsedCoordinates: (lat: Double, lon: Double)? {
        CoordinateValidator.parseAndValidate(
            latString: customLatitude,
            lonString: customLongitude
        )
    }
    
    func openWikipediaWithCustomLocation() -> URL? {
        guard let (lat, lon) = parsedCoordinates else {
            return nil
        }
        
        return WikipediaURLBuilder.makePlacesURL(lat: lat, lon: lon)
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
    }
    
    func clearCustomLocation() {
        customLocation = nil
        shouldShowCustomLocationOnMap = false
        customLatitude = ""
        customLongitude = ""
    }
    
    var allPlaces: [Place] {
        var result = places
        if let customLocation = customLocation {
            result.append(customLocation)
        }
        return result
    }
}

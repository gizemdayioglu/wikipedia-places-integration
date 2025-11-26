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
    
    init(getLocationsUseCase: GetLocationsUseCase) {
        self.getLocationsUseCase = getLocationsUseCase
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
    
    func openWikipediaWithCustomLocation() -> URL? {
        guard let lat = Double(customLatitude),
              let lon = Double(customLongitude) else {
            return nil
        }
        
        return WikipediaURLBuilder.makePlacesURL(lat: lat, lon: lon)
    }
    
    var isCustomLocationValid: Bool {
        guard let lat = Double(customLatitude),
              let lon = Double(customLongitude) else {
            return false
        }
        return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
    }
    
    func createCustomLocation() -> Place? {
        guard let lat = Double(customLatitude),
              let lon = Double(customLongitude),
              isCustomLocationValid else {
            return nil
        }
        
        return Place(
            id: "custom-\(lat),\(lon)",
            name: "Custom Location",
            latitude: lat,
            longitude: lon,
            description: "Custom coordinates"
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

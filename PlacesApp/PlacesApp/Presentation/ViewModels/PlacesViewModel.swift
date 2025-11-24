import Foundation
import SwiftUI

@MainActor
final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var customLatitude: String = ""
    @Published var customLongitude: String = ""
    
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
}

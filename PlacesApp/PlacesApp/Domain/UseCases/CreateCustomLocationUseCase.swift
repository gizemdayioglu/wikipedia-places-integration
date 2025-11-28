import Foundation

struct CreateCustomLocationUseCase {
    func execute(latString: String, lonString: String) -> Place? {
        guard let (lat, lon) = CoordinateValidator.parseAndValidate(
            latString: latString, lonString: lonString) else {
            return nil
        }
        
        return Place(
            id: "custom-\(lat),\(lon)",
            name: LocalizedStrings.customLocationName,
            latitude: lat,
            longitude: lon,
            description: NSLocalizedString("place.custom.coordinates", comment: "Custom coordinates description")
        )
    }
}
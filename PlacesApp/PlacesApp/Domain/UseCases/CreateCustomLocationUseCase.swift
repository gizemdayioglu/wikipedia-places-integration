import Foundation

struct CreateCustomLocationUseCase {
    func execute(latString: String, lonString: String) -> Place? {
        guard let (lat, lon) = CoordinateValidator.parseAndValidate(
            latString: latString, lonString: lonString) else {
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
}
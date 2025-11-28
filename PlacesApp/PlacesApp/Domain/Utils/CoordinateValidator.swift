import Foundation

struct CoordinateValidator {
    // MARK: - Constants
    
    static let minLatitude: Double = -90
    static let maxLatitude: Double = 90
    static let minLongitude: Double = -180
    static let maxLongitude: Double = 180
    
    // MARK: - Validation
    
    static func isValid(latitude: Double, longitude: Double) -> Bool {
        return latitude >= minLatitude && latitude <= maxLatitude &&
               longitude >= minLongitude && longitude <= maxLongitude
    }
    
    static func parseAndValidate(latString: String, lonString: String) -> (lat: Double, lon: Double)? {
        guard let lat = Double(latString),
              let lon = Double(lonString) else {
            return nil
        }
        
        guard isValid(latitude: lat, longitude: lon) else {
            return nil
        }
        
        return (lat, lon)
    }
}



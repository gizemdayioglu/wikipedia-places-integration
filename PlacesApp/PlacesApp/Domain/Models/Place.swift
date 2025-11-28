import Foundation
import CoreLocation

struct Place: Identifiable, Codable, Equatable {
    let id: String
    let name: String?
    let latitude: Double
    let longitude: Double
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
    
    init(id: String, name: String?, latitude: Double, longitude: Double, description: String? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        description = nil
        id = "\(latitude),\(longitude)"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var displayName: String {
        name ?? LocalizedStrings.locationCoordinates(
            lat: String(format: "%.2f", latitude),
            lon: String(format: "%.2f", longitude)
        )
    }
    
    var wikipediaDeepLinkURL: URL? {
        WikipediaURLBuilder.makePlacesURL(lat: latitude, lon: longitude)
    }

    func formattedLatitude(decimalPlaces: Int = 2) -> String {
        String(format: "%.\(decimalPlaces)f", latitude)
    }
    
    func formattedLongitude(decimalPlaces: Int = 2) -> String {
        String(format: "%.\(decimalPlaces)f", longitude)
    }
    
    var accessibilityValue: String {
        var parts: [String] = []
        
        if let desc = description {
            parts.append(desc)
        }
        
        parts.append(String(format: LocalizedStrings.latitudeLabel, formattedLatitude()))
        parts.append(String(format: LocalizedStrings.longitudeLabel, formattedLongitude()))
        
        return parts.joined(separator: ", ")
    }
}

struct PlacesResponse: Codable {
    let locations: [Place]
    
    enum CodingKeys: String, CodingKey {
        case locations
    }
}

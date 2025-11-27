import Foundation

struct WikipediaURLBuilder {
    static func makePlacesURL(lat: Double, lon: Double) -> URL? {
        guard CoordinateValidator.isValid(latitude: lat, longitude: lon) else {
            return nil
        }
        
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        return components.url
    }
}


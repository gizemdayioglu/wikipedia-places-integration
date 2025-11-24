import Foundation

struct WikipediaURLBuilder {
    static func makePlacesURL(lat: Double, lon: Double) -> URL? {
        guard lat >= -90, lat <= 90,
              lon >= -180, lon <= 180 else {
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


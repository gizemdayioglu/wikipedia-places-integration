import Foundation
import CoreLocation
import MapKit

struct MapRegionCalculator {
    struct Configuration {
        let defaultCenter: CLLocationCoordinate2D
        let defaultSpan: MKCoordinateSpan
        let paddingMultiplier: Double
        let minimumSpan: Double
        
        static let `default` = Configuration(
            defaultCenter: CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041),
            defaultSpan: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5),
            paddingMultiplier: 1.3,
            minimumSpan: 0.1
        )
    }
    
    static func calculateRegion(
        for places: [Place],
        configuration: Configuration = .default
    ) -> MKCoordinateRegion {
        guard !places.isEmpty else {
            return MKCoordinateRegion(
                center: configuration.defaultCenter,
                span: configuration.defaultSpan
            )
        }
        
        let latitudes = places.map { $0.latitude }
        let longitudes = places.map { $0.longitude }
        
        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let latDelta = max((maxLat - minLat) * configuration.paddingMultiplier, configuration.minimumSpan)
        let lonDelta = max((maxLon - minLon) * configuration.paddingMultiplier, configuration.minimumSpan)
        
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
}


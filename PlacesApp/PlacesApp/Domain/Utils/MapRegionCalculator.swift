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
        
        let lats = places.map(\.latitude)
        let lons = places.map(\.longitude)

        guard
            let minLat = lats.min(),
            let maxLat = lats.max(),
            let minLon = lons.min(),
            let maxLon = lons.max()
        else {
            return MKCoordinateRegion(
                center: configuration.defaultCenter,
                span: configuration.defaultSpan
            )
        }

        let latSpan = max(
            (maxLat - minLat) * configuration.paddingMultiplier,
            configuration.minimumSpan
        )

        let lonSpan = max(
            (maxLon - minLon) * configuration.paddingMultiplier,
            configuration.minimumSpan
        )

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        
        return MKCoordinateRegion(center: center, span: span)
    }
}


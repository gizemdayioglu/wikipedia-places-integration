import SwiftUI
import MapKit

struct PlacesMapView: UIViewRepresentable {
    let places: [Place]
    let customLocation: Place?
    let onPlaceTapped: (Place) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        
        var allPlaces = places
        if let customLocation = customLocation {
            allPlaces.append(customLocation)
        }
        
        let annotations = allPlaces.map { PlaceAnnotation(place: $0) }
        mapView.addAnnotations(annotations)
        
        if !allPlaces.isEmpty {
            let region = calculateRegion(for: allPlaces)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPlaceTapped: onPlaceTapped)
    }
    
    private func calculateRegion(for places: [Place]) -> MKCoordinateRegion {
        guard !places.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
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
        
        let latDelta = max((maxLat - minLat) * 1.3, 0.1)
        let lonDelta = max((maxLon - minLon) * 1.3, 0.1)
        
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        )
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let onPlaceTapped: (Place) -> Void
        
        init(onPlaceTapped: @escaping (Place) -> Void) {
            self.onPlaceTapped = onPlaceTapped
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? PlaceAnnotation else { return }
            onPlaceTapped(annotation.place)
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
}

class PlaceAnnotation: NSObject, MKAnnotation {
    let place: Place
    var coordinate: CLLocationCoordinate2D {
        place.coordinate
    }
    var title: String? {
        place.displayName
    }
    var subtitle: String? {
        if let description = place.description {
            return description
        }
        return "Latitude: \(String(format: "%.4f", place.latitude)), Longitude: \(String(format: "%.4f", place.longitude))"
    }
    
    init(place: Place) {
        self.place = place
        super.init()
    }
}

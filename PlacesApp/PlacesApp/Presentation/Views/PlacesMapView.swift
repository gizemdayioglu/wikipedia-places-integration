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
        mapView.isAccessibilityElement = false
        mapView.accessibilityTraits.insert(.allowsDirectInteraction)
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
        mapView.accessibilityValue = LocalizedStrings.mapLocationsShown(allPlaces.count)
        if !allPlaces.isEmpty {
            let region = calculateRegion(for: allPlaces)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPlaceTapped: onPlaceTapped)
    }
    
    private func calculateRegion(for places: [Place]) -> MKCoordinateRegion {
        return MapRegionCalculator.calculateRegion(for: places)
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
    
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }

            let identifier = "PlaceAnnotationView"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                ?? MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)

            annotationView.annotation = placeAnnotation
            annotationView.isAccessibilityElement = true
            annotationView.canShowCallout = false
            annotationView.accessibilityLabel = placeAnnotation.place.displayName
            let latFormatted = placeAnnotation.place.formattedLatitude()
            let lonFormatted = placeAnnotation.place.formattedLongitude()
            annotationView.accessibilityValue = String(format: NSLocalizedString("map.annotation.coordinates", comment: "Map annotation coordinates format"), latFormatted, lonFormatted)
            annotationView.accessibilityHint = LocalizedStrings.accessibilityOpenWikipediaLocation
            annotationView.accessibilityTraits.insert(.button)
    
            return annotationView
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
        return String(format: NSLocalizedString("map.annotation.subtitle", comment: "Map annotation subtitle format"), 
                     place.formattedLatitude(decimalPlaces: 4), 
                     place.formattedLongitude(decimalPlaces: 4))
    }
    
    init(place: Place) {
        self.place = place
        super.init()
    }
}

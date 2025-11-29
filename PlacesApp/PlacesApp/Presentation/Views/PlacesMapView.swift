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
        MapRegionCalculator.calculateRegion(for: places)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let onPlaceTapped: (Place) -> Void
        
        init(onPlaceTapped: @escaping (Place) -> Void) {
            self.onPlaceTapped = onPlaceTapped
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? PlaceAnnotation {
                onPlaceTapped(annotation.place)
                mapView.deselectAnnotation(annotation, animated: true)
                return
            }
            if let cluster = view.annotation as? MKClusterAnnotation {
                mapView.deselectAnnotation(cluster, animated: false)
            }
        }

    
        func mapView(_ mapView: MKMapView,
                     viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let cluster = annotation as? MKClusterAnnotation {
                let annotationView = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "Cluster")

                annotationView.clusteringIdentifier = "place"
                annotationView.isAccessibilityElement = true
                annotationView.accessibilityTraits = [.button]
                annotationView.accessibilityLabel = LocalizedStrings.locationsCount(cluster.memberAnnotations.count)

                return annotationView
            }

            guard let placeAnnotation = annotation as? PlaceAnnotation else { return nil }

            let identifier = "PlaceAnnotationView"
            let annotationView =
                mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                ?? MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)

            annotationView.clusteringIdentifier = "place"
            annotationView.annotation = placeAnnotation
            annotationView.isAccessibilityElement = true
            annotationView.canShowCallout = false
            annotationView.accessibilityLabel = placeAnnotation.place.displayName
            annotationView.accessibilityValue = placeAnnotation.place.accessibilityValue
            annotationView.accessibilityHint = LocalizedStrings.accessibilityOpenWikipediaLocation
            annotationView.accessibilityTraits.insert(.button)

            return annotationView
        }
    }
}

final class PlaceAnnotation: NSObject, MKAnnotation {
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

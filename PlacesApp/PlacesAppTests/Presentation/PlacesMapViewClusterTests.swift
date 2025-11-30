import XCTest
import MapKit
@testable import PlacesApp

final class PlacesMapViewClusterTests: XCTestCase {
    
    func testAnnotationClusteringIdentifierIsSet() {
        // Given
        let place = Place(id: "1",
                          name: "Test",
                          latitude: 52.0,
                          longitude: 4.0)
        
        let annotation = PlaceAnnotation(place: place)
        let mapView = MKMapView()
        let view = PlacesMapView(
            places: [place],
            customLocation: nil,
            onPlaceTapped: { _ in }
        )
        
        let coordinator = view.makeCoordinator()
        
        // When
        let annotationView = coordinator.mapView(
            mapView,
            viewFor: annotation
        ) as? MKMarkerAnnotationView
        
        // Then
        XCTAssertEqual(annotationView?.clusteringIdentifier, "place")
    }
    
    func testClusterAnnotationHasAccessibilityProperties() {
        // Given
        let annotation1 = PlaceAnnotation(place: .init(id: "1",
                                                name: "A",
                                                latitude: 1,
                                                longitude: 1))
        let annotation2 = PlaceAnnotation(place: .init(id: "2",
                                                name: "B",
                                                latitude: 1.0001,
                                                longitude: 1.0001))
        
        let cluster = MKClusterAnnotation(memberAnnotations: [annotation1, annotation2])
        
        let mapView = MKMapView()
        let coordinator = PlacesMapView(
            places: [],
            customLocation: nil,
            onPlaceTapped: { _ in }
        ).makeCoordinator()

        // When
        guard let view = coordinator.mapView(
            mapView,
            viewFor: cluster
        ) as? MKMarkerAnnotationView else {
            XCTFail("Expected MKMarkerAnnotationView for cluster")
            return
        }

        // Then
        XCTAssertTrue(view.isAccessibilityElement)
        XCTAssertTrue(view.accessibilityTraits.contains(.button))
        XCTAssertNotNil(view.accessibilityLabel)
        XCTAssertFalse(view.accessibilityLabel?.isEmpty ?? true)
        XCTAssertNotNil(view.accessibilityHint)
        XCTAssertFalse(view.accessibilityHint?.isEmpty ?? true)
    }

}


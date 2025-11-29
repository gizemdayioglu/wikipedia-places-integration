import Foundation

enum LocalizedStrings {
    static let places = NSLocalizedString("places.title", comment: "Places screen title")
    static let customLocation = NSLocalizedString("custom.location.title", comment: "Custom location screen title")

    static let map = NSLocalizedString("view.mode.map", comment: "Map view mode")
    static let list = NSLocalizedString("view.mode.list", comment: "List view mode")
    static let viewMode = NSLocalizedString("view.mode", comment: "View mode picker label")
    
    static let showLocation = NSLocalizedString("button.show.location", comment: "Show location button")
    static let showLocationDisabled = NSLocalizedString("button.show.location.disabled", comment: "Show location button disabled state")
    static let done = NSLocalizedString("button.done", comment: "Done button")
    static let ok = NSLocalizedString("button.ok", comment: "OK button")
    static let addCustomLocation = NSLocalizedString("button.add.custom.location", comment: "Add custom location button")
    static let refresh = NSLocalizedString("button.refresh", comment: "Refresh button")
    
    static let enterCoordinates = NSLocalizedString("form.enter.coordinates", comment: "Enter coordinates section header")
    static let latitude = NSLocalizedString("form.latitude", comment: "Latitude field label")
    static let longitude = NSLocalizedString("form.longitude", comment: "Longitude field label")
    static let latitudePlaceholder = NSLocalizedString("form.latitude.placeholder", comment: "Latitude field placeholder")
    static let longitudePlaceholder = NSLocalizedString("form.longitude.placeholder", comment: "Longitude field placeholder")
    
    static let loadingPlaces = NSLocalizedString("message.loading.places", comment: "Loading places message")
    static let noPlacesFound = NSLocalizedString("message.no.places.found", comment: "No places found message")
    static let error = NSLocalizedString("message.error", comment: "Error alert title")
    
    static let accessibilityViewModeSelector = NSLocalizedString("accessibility.view.mode.selector", comment: "View mode selector accessibility label")
    static let accessibilityViewModeHint = NSLocalizedString("accessibility.view.mode.hint", comment: "View mode selector accessibility hint")
    static let accessibilityAddCustomLocation = NSLocalizedString("accessibility.add.custom.location", comment: "Add custom location button accessibility label")
    static let accessibilityAddCustomLocationHint = NSLocalizedString("accessibility.add.custom.location.hint", comment: "Add custom location button accessibility hint")
    static let accessibilityEnterCoordinatesHint = NSLocalizedString("accessibility.enter.coordinates.hint", comment: "Enter coordinates accessibility hint")
    static let accessibilityLatitudeHint = NSLocalizedString("accessibility.latitude.hint", comment: "Latitude field accessibility hint")
    static let accessibilityLongitudeHint = NSLocalizedString("accessibility.longitude.hint", comment: "Longitude field accessibility hint")
    static let accessibilityShowLocationHint = NSLocalizedString("accessibility.show.location.hint", comment: "Show location button accessibility hint")
    static let accessibilityShowLocationDisabledHint = NSLocalizedString("accessibility.show.location.disabled.hint", comment: "Show location button disabled accessibility hint")
    static let accessibilityDoneHint = NSLocalizedString("accessibility.done.hint", comment: "Done button accessibility hint")
    static let accessibilityOpenWikipedia = NSLocalizedString("accessibility.open.wikipedia", comment: "Open Wikipedia accessibility hint")
    static let accessibilityOpenWikipediaLocation = NSLocalizedString("accessibility.open.wikipedia.location", comment: "Open Wikipedia at location accessibility hint")
    static let accessibilityNoPlacesFound = NSLocalizedString("accessibility.no.places.found", comment: "No places found accessibility label")
    static let accessibilityRefresh = NSLocalizedString("accessibility.refresh", comment: "Refresh button accessibility label")
    static let accessibilityRefreshHint = NSLocalizedString("accessibility.refresh.hint", comment: "Refresh button accessibility hint")
    
    static let location = NSLocalizedString("place.location", comment: "Location label for places without name")
    static let customLocationName = NSLocalizedString("place.custom.location.name", comment: "Custom location name")
    static let latitudeLabel = NSLocalizedString("place.latitude", comment: "Latitude label in accessibility")
    static let longitudeLabel = NSLocalizedString("place.longitude", comment: "Longitude label in accessibility")
    static let locationsCountFormat = NSLocalizedString("place.locations.count", comment: "Locations count format")
    static let locationCountFormat = NSLocalizedString("place.location.count", comment: "Location count format (singular)")
    
    static let mapShown = NSLocalizedString("map.shown", comment: "shown text")
    
    static func locationsCount(_ count: Int) -> String {
        let format = count == 1 ? locationCountFormat : locationsCountFormat
        return String(format: format, count)
    }
    
    static func locationCoordinates(lat: String, lon: String) -> String {
        String(format: NSLocalizedString("place.location.coordinates", comment: "Location with coordinates format"), lat, lon)
    }
    
    static func mapLocationsShown(_ count: Int) -> String {
        locationsCount(count) + " " + mapShown
    }
}


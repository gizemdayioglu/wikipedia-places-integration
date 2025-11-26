# Places App

A demo app that opens the Wikipedia iOS app's Places tab with custom coordinates using deep linking. Built with SwiftUI using MVVM and Clean Architecture.

## Features

- Fetches locations from a remote JSON endpoint
- **Map and List views** with toggle between them (map view by default)
- Opens Wikipedia app's Places tab with coordinates when tapping a location
- Allows entering custom latitude/longitude coordinates that appear in both map and list views
- Card-style UI design with modern iOS styling
- Empty state handling with helpful messages
- Pull-to-refresh support
- SwiftUI with full accessibility support
- Uses async/await for network operations
- Unit tests for ViewModels and UseCases
- UI tests for main user flows

## Architecture

The app follows Clean Architecture with clear layer:

```
PlacesApp/
├── Application/
│   └── DependencyContainer.swift
├── Domain/
│   ├── Models/
│   │   └── Place.swift
│   ├── Utils/
│   │   └── WikipediaURLBuilder.swift
│   ├── Protocols/
│   │   └── PlacesRepositoryProtocol.swift
│   └── UseCases/
│       └── GetLocationsUseCase.swift
├── Data/
│   ├── Network/
│   │   └── PlacesNetworkService.swift
│   └── Repositories/
│       └── PlacesRepository.swift
└── Presentation/
    ├── Theme.swift
    ├── ViewModels/
    │   └── PlacesViewModel.swift
    └── Views/
        ├── PlacesListView.swift
        ├── PlacesMapView.swift
        ├── PlaceRowView.swift
        ├── EmptyStateView.swift
        └── CustomLocationView.swift
```

## Setup

### Requirements

- Xcode 14.0+
- iOS 15.0+
- Swift 5.7+

### Installation

1. Open `PlacesApp.xcodeproj` in Xcode
2. Select the PlacesApp scheme
3. Build and run

The app fetches locations from:
`https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json`

## User Interface

The app features a modern, clean UI with:

- **Map View** (default): Interactive map showing all locations as pins, including custom locations. Tap any pin to open Wikipedia.
- **List View**: Card-style list of locations with location icons and coordinates. Custom locations appear at the end of the list.
- **Toggle Bar**: Segmented control at the top to switch between Map and List views.
- **Custom Location**: Enter coordinates to add a custom location that appears in both map and list views.
- **Empty State**: Friendly message when no locations are available.
- **Pull-to-Refresh**: Swipe down to reload locations.
- **Card Design**: Modern card-style rows with shadows and rounded corners.
- **Consistent Theme**: Centralized color scheme for maintainability.

## Deep Linking

The app uses this URL format to open Wikipedia:

```
wikipedia://places?lat=<latitude>&lon=<longitude>
```

Examples:
- `wikipedia://places?lat=52.3676&lon=4.9041` (Amsterdam)
- `wikipedia://places?lat=51.5074&lon=-0.1278` (London)

**Note on Universal Links:** Universal links (https:// URLs) are normally more secure because of domain verification, and they fall back to the website if the app isn’t installed. But Wikipedia doesn’t support universal links for opening the Places tab with coordinates. So I use the`wikipedia://` scheme instead, which is the standard way to deep-link into the Wikipedia app.

## Testing

### Running Tests

**In Xcode:**
1. Open `PlacesApp.xcodeproj`
2. Press `Cmd+U` or go to Product → Test
3. This runs both unit tests and UI tests

### Unit Tests

Test coverage includes:
- `PlacesViewModelTests`: ViewModel logic, validation, edge cases, custom location creation, and data consistency between map/list views
- `GetLocationsUseCaseTests`: Use case execution and error handling
- `PlaceModelTests`: Model properties, URL generation, and decoding
- `WikipediaURLBuilderTests`: URL building with valid and invalid coordinates
- `PlacesRepositoryTests`: Repository success and error paths
- `PlacesNetworkServiceTests`: Network service with mocked URLSession
- `PlaceDecodingTests`: JSON decoding for Place and PlacesResponse
- `NetworkErrorTests`: Error descriptions and types
- `AccessibilityTests`: Accessibility labels and text generation

### UI Tests

Run UI tests by selecting the PlacesApp scheme and pressing `Cmd+U` (runs both unit and UI tests), or run only UI tests:
- In Xcode: Product → Test, or use the Test Navigator (Cmd+6) to run individual UI tests

UI tests cover:
- Places list loading
- Map and list view toggling
- Pull-to-refresh functionality
- Tapping locations (both map pins and list items)
- Custom location input and validation
- Showing custom locations in both map and list views

## Wikipedia App Changes

The Wikipedia app was modified to support coordinate-based deep linking:

1. **NSUserActivity+WMFExtensions.m**: Extracts `lat` and `lon`
2. **PlacesViewController.swift**: Added `showLocation(latitude:longitude:)`
3. **WMFAppViewController.m**: Updated to handle coordinates in Places activity

## Swift Concurrency

The app uses modern Swift Concurrency:
- `async/await` for network calls
- `@MainActor` for UI updates
- `Task` for structured concurrency

## iOS Version Support

The app supports iOS 15.0 and later, including iOS 15, 16, and 17. All features work across these versions without any version-specific code.

## UI Design

The app uses a clean, modern design with:
- Card-style rows with subtle shadows
- Consistent color theme (blue accent)
- Empty states for better UX
- Native iOS segmented control for view switching
- Full accessibility support with VoiceOver labels

## Notes

- Coordinates are validated (latitude: -90 to 90, longitude: -180 to 180)
- Custom locations are automatically shown in both map and list views for consistency
- The app handles network errors gracefully
- Full accessibility support with VoiceOver labels
- JSON supports locations with or without names
- Map view uses MapKit with efficient annotation handling
- List view uses lazy loading for performance

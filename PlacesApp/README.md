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
- Localization support for English and Dutch
- Uses async/await for network operations
- Unit tests for ViewModels and UseCases
- UI tests for main user flows

## Architecture

The app follows Clean Architecture with clear layer:

```
PlacesApp/
├── Application/
│   ├── DependencyContainer.swift          # Dependency injection container
│   └── TestDependencyContainer.swift     # Test dependency container with mock data
├── Domain/
│   ├── Models/
│   │   └── Place.swift                    # Domain model with formatting methods
│   ├── Constants/
│   │   └── ErrorMessages.swift            # Centralized error messages
│   ├── Utils/
│   │   ├── CoordinateValidator.swift      # Coordinate validation logic
│   │   ├── MapRegionCalculator.swift      # Map region calculation algorithm
│   │   ├── WikipediaURLBuilder.swift      # Deep link URL builder
│   │   ├── LocalizedStrings.swift         # Centralized localization helper
│   │   └── NetworkReachability.swift      # Network connectivity monitoring
│   ├── Protocols/
│   │   └── PlacesRepositoryProtocol.swift  # Repository interface
│   └── UseCases/
│       ├── GetLocationsUseCase.swift       # Fetch locations use case
│       └── CreateCustomLocationUseCase.swift # Create custom location use case
├── Data/
│   ├── Network/
│   │   └── PlacesNetworkService.swift     # Network service with configurable URL
│   └── Repositories/
│       └── PlacesRepository.swift         # Repository implementation
├── Resources/
│   ├── mock_locations.json                # Mock data for UI tests
│   ├── en.lproj/
│   │   └── Localizable.strings           # English localizations
│   └── nl.lproj/
│       └── Localizable.strings           # Dutch localizations
└── Presentation/
    ├── Theme.swift                         # App theme and colors
    ├── ViewModels/
    │   └── PlacesViewModel.swift          # ViewModel (UI state management only)
    └── Views/
        ├── PlacesListView.swift            # Main list/map view
        ├── PlacesMapView.swift            # Map view component
        ├── PlaceRowView.swift              # Location row component
        ├── EmptyStateView.swift            # Empty state component
        ├── ErrorStateView.swift            # Generic error state component
        └── CustomLocationView.swift        # Custom location input form
```

### Architecture Principles

- **Domain Layer**: Contains all business logic, validation rules, and use cases
- **Data Layer**: Handles data fetching and persistence (no business logic)
- **Presentation Layer**: Only contains UI logic and state management
- **Dependency Injection**: All dependencies injected via `DependencyContainer`

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

- **Map View** (default): Interactive map showing all locations as pins, including custom locations. Nearby pins are automatically grouped into clusters for better readability. Tap any pin to open Wikipedia.
- **List View**: Card-style list of locations with location icons and coordinates. Custom locations appear at the end of the list.
- **Toggle Bar**: Segmented control at the top to switch between Map and List views.
- **Custom Location**: Enter coordinates to add a custom location that appears in both map and list views.
- **Empty State**: Friendly message when no locations are available.
- **Error State**: Generic error view with retry button for network errors and other failures.
- **Pull-to-Refresh**: Swipe down to reload locations in list view. Refresh button in toolbar for map view.
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

**Test Structure:**
- Tests are organized by layer: `Data/`, `Domain/`, `Presentation/`, `Utils/`
- All mock classes are centralized in `Mocks/` folder for easy discovery and reuse

Test coverage includes:
- `PlacesViewModelTests`: ViewModel logic, validation, edge cases, custom location creation, and data consistency between map/list views
- `GetLocationsUseCaseTests`: Use case execution and error handling
- `CreateCustomLocationUseCaseTests`: Custom location creation with validation
- `PlaceModelTests`: Model properties, URL generation, decoding, and formatting methods
- `WikipediaURLBuilderTests`: URL building with valid and invalid coordinates
- `PlacesRepositoryTests`: Repository success and error paths
- `PlacesNetworkServiceTests`: Network service with mocked URLSession, including decoding error handling
- `PlaceDecodingTests`: JSON decoding for Place and PlacesResponse
- `NetworkErrorTests`: Error descriptions and types, including decoding errors
- `NetworkReachabilityTests`: Network connectivity checking
- `PlaceRowViewTests`: Accessibility labels, values, and text generation
- `ErrorStateViewTests`: Error state view component instantiation and retry action

### UI Tests

Run UI tests by selecting the PlacesApp scheme and pressing `Cmd+U` (runs both unit and UI tests), or run only UI tests:
- In Xcode: Product → Test, or use the Test Navigator (Cmd+6) to run individual UI tests

**UI Test Structure:**
- `PlacesAppUITests`: Main UI tests for user flows
- `AccessibilityUITests`: Accessibility testing for all views
- `ErrorStateUITests`: Error state view and retry functionality
- `XCUIElement+Extensions.swift`: Shared extension with `waitForVisible` helper for reliable element waiting

UI tests cover:
- Loading and displaying the places list
- Switching between map and list views
- Pull-to-refresh to reload locations
- Custom location button opening the input form
- Entering and validating custom coordinates
- Showing custom locations on both map and list views
- Error state view visibility and retry button functionality (`ErrorStateUITests`)

**UI Test Launch Arguments:**
- `UITest_MockData`: Uses mock data from `mock_locations.json` instead of network requests, making tests independent of network connectivity
- `UITest_ErrorState`: Forces the app to display error state immediately on launch for testing error handling UI

## Swift Concurrency

The app uses modern Swift Concurrency:
- `async/await` for network calls
- `@MainActor` for UI updates
- `Task` for structured concurrency

## iOS Version Support

The app supports iOS 15 and later. It uses a backward-compatible map implementation with MKMapView

## UI Design

The app uses a clean, modern design with:
- Card-style rows with subtle shadows
- Consistent color theme (blue accent)
- Empty states for better UX
- Native iOS segmented control for view switching
- Full accessibility support with VoiceOver labels

## Notes

- Coordinates are validated using `CoordinateValidator` (latitude: -90 to 90, longitude: -180 to 180)
- Custom locations are automatically shown in both map and list views for consistency
- The app checks network connectivity before making network requests using `NetworkReachability`
- Network errors are handled with proper error types and localized error messages
- Error states are displayed using a reusable `ErrorStateView` component with retry functionality
- View state is managed using an enum-based `PlacesViewState` for clarity
- Full accessibility support with VoiceOver labels, hints, and values
- JSON supports locations with or without names
- Map view uses MapKit with efficient annotation handling, automatic pin clustering for nearby locations
- List view uses lazy loading for performance
- All coordinate formatting centralized in `Place` model for consistency
- All user-facing strings are localized
- UI tests use mock data from `mock_locations.json` to run independently of network connectivity
- `TestDependencyContainer` provides mock network services and data for UI testing

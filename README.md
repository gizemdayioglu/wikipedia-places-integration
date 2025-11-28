# Wikipedia Places Integration

This monorepo contains two iOS projects that work together to show deep linking between apps.

## What's Here

- **PlacesApp**: A demo app that displays locations and opens the Wikipedia app's Places tab with specific coordinates
- **wikipedia-ios**: A modified version of the Wikipedia iOS app that supports opening the Places tab with custom coordinates via deep linking

## The Assignment

The goal was to modify the Wikipedia iOS app so it can be opened directly to the Places tab showing a specific location (via coordinates), instead of always showing the current location.

## Setup

This project contains a Git submodule. Make sure you clone the repository using:

```bash
git clone --recurse-submodules https://github.com/gizemdayioglu/wikipedia-places-integration.git
```

### Setup Wikipedia iOS App

Wikipedia requires additional setup before running:

```bash
cd wikipedia-places-integration/wikipedia-ios
./scripts/setup
```

This installs dependencies and configures the project.

## Quick Start

### PlacesApp

1. Open `PlacesApp/PlacesApp.xcodeproj` in Xcode
2. Select the PlacesApp scheme
3. Build and run (Cmd+R)

For detailed information about PlacesApp, see [PlacesApp/README.md](PlacesApp/README.md).

**Note:** PlacesApp supports localization in English and Dutch

### Wikipedia App

1. Open `wikipedia-ios/Wikipedia.xcodeproj` in Xcode
2. Select the Wikipedia scheme
3. Build and run (Cmd+R)

Note: The Wikipedia app is a large project. You may need to install dependencies or run setup scripts.

## Wikipedia App Changes

I modified the Wikipedia app so it can open the Places tab directly to a specific location using coordinates.
When you send it a deep link like: 
`wikipedia://places?lat=52.3676&lon=4.9041`, 
it extracts those coordinates, makes sure they're valid, and then centers the map on that location.

The implementation is done across three files:

1. **NSUserActivity+WMFExtensions.m**  
   Parses the deep link URL, extracts the latitude and longitude values, and validates them so that only valid coordinates are passed through.

2. **PlacesViewController.swift**  
   Adds a method that takes valid coordinates and updates the map view to show that location.

3. **WMFAppViewController.m**  
   Handles incoming Places deep links and connects the flow together by showing the target location on the map if coordinates are valid, or falling back safely when they are not.

## Testing the Integration

1. Run PlacesApp on a device or simulator
2. Run the Wikipedia app on the same device
3. In PlacesApp, tap any location
4. The Wikipedia app should open directly to the Places tab showing that location


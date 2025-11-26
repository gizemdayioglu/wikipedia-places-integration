# Wikipedia Places Integration

This repository contains two iOS projects that work together to show deep linking between apps.

## What's Here

- **PlacesApp**: A demo app that displays locations and opens the Wikipedia app's Places tab with specific coordinates
- **wikipedia-ios**: A modified version of the Wikipedia iOS app that supports opening the Places tab with custom coordinates via deep linking

## The Assignment

The goal was to modify the Wikipedia iOS app so it can be opened directly to the Places tab showing a specific location (via coordinates), instead of always showing the current location.

## Quick Start

### PlacesApp

1. Open `PlacesApp/PlacesApp.xcodeproj` in Xcode
2. Select the PlacesApp scheme
3. Build and run (Cmd+R)

For detailed information about PlacesApp, see [PlacesApp/README.md](PlacesApp/README.md).

### Wikipedia App

1. Open `wikipedia-ios/Wikipedia.xcodeproj` in Xcode
2. Select the Wikipedia scheme
3. Build and run (Cmd+R)

Note: The Wikipedia app is a large project. You may need to install dependencies or run setup scripts.

## Wikipedia App Changes

The Wikipedia app was modified in 3 files to support coordinate-based deep linking:

1. **NSUserActivity+WMFExtensions.m**: Extracts latitude and longitude from deep link URLs
2. **PlacesViewController.swift**: Added a method to show a specific location by coordinates
3. **WMFAppViewController.m**: Updated to handle coordinates in the Places activity

The deep link format is:
```
wikipedia://places?lat=<latitude>&lon=<longitude>
```

## Testing the Integration

1. Run PlacesApp on a device or simulator
2. Run the Wikipedia app on the same device
3. In PlacesApp, tap any location
4. The Wikipedia app should open directly to the Places tab showing that location


import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String?

    private var showLocationButtonLabel: String {
        viewModel.isCustomLocationValid ? "Show Location" : "Show Location, disabled"
    }
    
    private var showLocationButtonHint: String {
        viewModel.isCustomLocationValid
            ? "Shows the location on the map and in the list"
            : "Enter valid latitude and longitude to enable"
    }
    
    var body: some View {
        NavigationView {
            Form {
                coordinatesSection
                showLocationSection
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    doneButton
                }
            }
            .onAppear {
                viewModel.clearCustomLocation()
            }
        }
    }

    private var coordinatesSection: some View {
        Section(header: coordinatesHeader) {
            latitudeField
            longitudeField
        }
    }
    
    private var coordinatesHeader: some View {
        Text("Enter Coordinates")
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint("Enter the latitude and longitude")
    }
    
    private var latitudeField: some View {
        TextField("Latitude (-90 to 90)", text: $viewModel.customLatitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel("Latitude")
            .accessibilityHint("Enter a number between minus ninety and ninety")
            .accessibilityIdentifier("LatitudeField")
    }
    
    private var longitudeField: some View {
        TextField("Longitude (-180 to 180)", text: $viewModel.customLongitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel("Longitude")
            .accessibilityHint("Enter a number between minus one eighty and one eighty")
            .accessibilityIdentifier("LongitudeField")
    }
    
    private var showLocationSection: some View {
        Section {
            Button(action: showOnMap) {
                HStack {
                    Spacer()
                    Text("Show Location")
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .disabled(!viewModel.isCustomLocationValid)
            .accessibilityIdentifier("ShowLocationButton")
            .accessibilityLabel(showLocationButtonLabel)
            .accessibilityHint(showLocationButtonHint)
        }
    }
    
    private var doneButton: some View {
        Button("Done", action: { dismiss() })
            .accessibilityIdentifier("DoneButton")
            .accessibilityLabel("Done")
            .accessibilityHint("Close this screen")
    }

    private func showOnMap() {
        viewModel.showCustomLocationOnMap()
        dismiss()
    }
}

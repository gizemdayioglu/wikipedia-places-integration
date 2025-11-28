import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String?

    private var showLocationButtonLabel: String {
        viewModel.isCustomLocationValid ? LocalizedStrings.showLocation : LocalizedStrings.showLocationDisabled
    }
    
    private var showLocationButtonHint: String {
        viewModel.isCustomLocationValid
            ? LocalizedStrings.accessibilityShowLocationHint
            : LocalizedStrings.accessibilityShowLocationDisabledHint
    }
    
    var body: some View {
        NavigationView {
            Form {
                coordinatesSection
                showLocationSection
            }
            .navigationTitle("custom.location.title")
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
        Text("form.enter.coordinates")
            .foregroundColor(.primary)
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint(LocalizedStrings.accessibilityEnterCoordinatesHint)
    }
    
    private var latitudeField: some View {
        TextField("form.latitude.placeholder", text: $viewModel.customLatitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel(LocalizedStrings.latitude)
            .accessibilityHint(LocalizedStrings.accessibilityLatitudeHint)
            .accessibilityIdentifier("LatitudeField")
    }
    
    private var longitudeField: some View {
        TextField("form.longitude.placeholder", text: $viewModel.customLongitude)
            .keyboardType(.decimalPad)
            .accessibilityLabel(LocalizedStrings.longitude)
            .accessibilityHint(LocalizedStrings.accessibilityLongitudeHint)
            .accessibilityIdentifier("LongitudeField")
    }
    
    private var showLocationSection: some View {
        Section {
            Button(action: showOnMap) {
                HStack {
                    Spacer()
                    Text("button.show.location")
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
        Button("button.done", action: { dismiss() })
            .accessibilityIdentifier("DoneButton")
            .accessibilityLabel(LocalizedStrings.done)
            .accessibilityHint(LocalizedStrings.accessibilityDoneHint)
    }

    private func showOnMap() {
        viewModel.showCustomLocationOnMap()
        dismiss()
    }
}

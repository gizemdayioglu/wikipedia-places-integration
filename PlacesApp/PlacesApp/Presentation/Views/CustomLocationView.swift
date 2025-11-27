import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Coordinates")
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityHint("Enter the latitude and longitude")) {
                    TextField("Latitude (-90 to 90)", text: $viewModel.customLatitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter a number between minus ninety and ninety")
                        .accessibilityIdentifier("LatitudeField")
                    
                    TextField("Longitude (-180 to 180)", text: $viewModel.customLongitude)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter a number between minus one eighty and one eighty")
                        .accessibilityIdentifier("LongitudeField")
                }
                
                Section {
                    Button {
                        showOnMap()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Show Location")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isCustomLocationValid)
                    .accessibilityIdentifier("ShowLocationButton")
                    .accessibilityHint(viewModel.isCustomLocationValid
                                       ? "Shows the location on the map and in the list"
                                       : "Enter valid latitude and longitude to enable")
                }
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .accessibilityIdentifier("DoneButton")
                    .accessibilityLabel("Done")
                    .accessibilityHint("Close this screen")
                }
            }
            .onAppear {
                viewModel.clearCustomLocation()
            }
        }
    }
    
    private func showOnMap() {
        viewModel.showCustomLocationOnMap()
        dismiss()
    }
}

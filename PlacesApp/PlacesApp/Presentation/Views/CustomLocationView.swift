import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Coordinates")) {
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
                        openWikipediaWithCustomLocation()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Open in Wikipedia")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isCustomLocationValid)
                    .accessibilityIdentifier("OpenWikipediaButton")
                    .accessibilityHint(viewModel.isCustomLocationValid
                                       ? "Opens Wikipedia app with the entered coordinates"
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
                }
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                if let msg = errorMessage {
                    Text(msg)
                }
            }
        }
    }
    
    private func openWikipediaWithCustomLocation() {
        guard let url = viewModel.openWikipediaWithCustomLocation() else { return }
        
        UIApplication.shared.open(url) { success in
            if success {
                dismiss()
            } else {
                errorMessage = "Wikipedia app is not installed. Please install and run the Wikipedia app first."
            }
        }
    }
}

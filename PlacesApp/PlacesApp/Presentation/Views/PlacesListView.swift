import SwiftUI

struct PlacesListView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @State private var showCustomLocation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading places...")
                } else {
                    List(viewModel.places) { place in
                        PlaceRowView(place: place)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                openWikipedia(for: place)
                            }
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint("Opens Wikipedia at this location")
                    }
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCustomLocation = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .accessibilityLabel("Add custom location")
                    }
                    .accessibilityIdentifier("AddCustomLocationButton")
                }
            }
            .sheet(isPresented: $showCustomLocation) {
                CustomLocationView()
                    .environmentObject(viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let msg = viewModel.errorMessage {
                    Text(msg)
                }
            }
            .task {
                await viewModel.loadPlaces()
            }
        }
    }
    
    private func openWikipedia(for place: Place) {
        guard let url = place.wikipediaDeepLinkURL else { return }
        UIApplication.shared.open(url) { success in
            if !success {
                viewModel.errorMessage = "Wikipedia app is not installed. Please install and run the Wikipedia app first."
            }
        }
    }
}


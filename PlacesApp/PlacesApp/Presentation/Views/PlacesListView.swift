import SwiftUI

enum ViewMode: String, CaseIterable {
    case map = "Map"
    case list = "List"
}

struct PlacesListView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @State private var showCustomLocation = false
    @State private var viewMode: ViewMode = .map
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented control toggle bar
                Picker("View Mode", selection: $viewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .accessibilityLabel("View mode selector")
                .accessibilityIdentifier("ViewModeSelector")
                .accessibilityHint("Switch between map and list view")
                
                if viewModel.isLoading {
                    ProgressView("Loading places...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("Loading places")
                        .accessibilityIdentifier("LoadingProgressView")
                        .accessibilityValue("Loading")
                } else if viewMode == .map {
                    PlacesMapView(
                        places: viewModel.places,
                        customLocation: viewModel.customLocation
                    ) { place in
                        openWikipedia(for: place)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Map showing locations")
                    .accessibilityIdentifier("PlacesMapView")
                } else if viewModel.allPlaces.isEmpty {
                    EmptyStateView()
                } else {
                    List(viewModel.allPlaces) { place in
                        PlaceRowView(place: place) {
                            openWikipedia(for: place)
                        }
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openWikipedia(for: place)
                        }
                    }
                    .listStyle(.plain)
                    .accessibilityLabel("List of \(viewModel.allPlaces.count) locations")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCustomLocation = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .accessibilityLabel("Add custom location")
                            .accessibilityHint("Opens a form to enter coordinates")
                    }
                    .accessibilityIdentifier("AddCustomLocationButton")
                }
            }
            .sheet(isPresented: $showCustomLocation) {
                CustomLocationView()
                    .environmentObject(viewModel)
            }
            .alert("Error", isPresented: $showError, presenting: viewModel.errorMessage) { _ in
                Button("OK") {
                    showError = false
                    viewModel.errorMessage = nil
                }
                .accessibilityIdentifier("ErrorAlertOKButton")
            } message: {_ in 
                if let msg = viewModel.errorMessage {
                    Text(msg)
                }
            }
            .refreshable {
                await viewModel.loadPlaces()
            }
            .task {
                await viewModel.loadPlaces()
            }
            .onChange(of: viewModel.shouldShowCustomLocationOnMap) { shouldShow in
                if shouldShow {
                    viewMode = .map
                    viewModel.shouldShowCustomLocationOnMap = false
                }
            }
        }
    }
    
    private func openWikipedia(for place: Place) {
        guard let url = place.wikipediaDeepLinkURL else { return }
        UIApplication.shared.open(url) { success in
            if !success {
                viewModel.errorMessage = ErrorMessages.wikipediaAppNotInstalled
                showError = true
            }
        }
    }
}


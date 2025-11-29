import SwiftUI

enum ViewMode: String, CaseIterable {
    case map
    case list
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .map: return "view.mode.map"
        case .list: return "view.mode.list"
        }
    }
}

struct PlacesListView: View {
    @EnvironmentObject var viewModel: PlacesViewModel
    @State private var showCustomLocation = false
    @State private var viewMode: ViewMode = .map
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                viewModeSelector
                contentView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("places.title")
            .onAppear {
                if ProcessInfo.processInfo.arguments.contains("UITest_ErrorState") {
                    viewModel.state = .error(ErrorMessages.noInternetConnection)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if viewMode == .map || viewModel.allPlaces.isEmpty {
                            refreshButton
                        }
                        addCustomLocationButton
                    }
                }
            }
            .sheet(isPresented: $showCustomLocation) {
                CustomLocationView()
                    .environmentObject(viewModel)
            }
            .alert("message.error", isPresented: $showError, presenting: viewModel.errorMessage) { _ in
                Button("button.ok") {
                    showError = false
                }
                .accessibilityIdentifier("ErrorAlertOKButton")
            } message: { message in
                Text(message)
            }
            .refreshable {
                await viewModel.loadPlaces()
            }
            .task {
                if !ProcessInfo.processInfo.arguments.contains("UITest_ErrorState") {
                    await viewModel.loadPlaces()
                }
            }
            .onChange(of: viewModel.shouldShowCustomLocationOnMap) { shouldShow in
                if shouldShow {
                    viewMode = .map
                    viewModel.shouldShowCustomLocationOnMap = false
                }
            }
        }
    }
}

private extension PlacesListView {
    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .error(let message):
            errorView(message: message)
        case .empty:
            emptyView
        case .loaded:
            if viewMode == .map {
                mapView
            } else {
                listView
            }
        }
    }
}

private extension PlacesListView {
    
    var viewModeSelector: some View {
        Picker("view.mode", selection: $viewMode) {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                Text(mode.localizedName).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .accessibilityLabel(LocalizedStrings.accessibilityViewModeSelector)
        .accessibilityIdentifier("ViewModeSelector")
        .accessibilityHint(LocalizedStrings.accessibilityViewModeHint)
    }
    
    var loadingView: some View {
        ProgressView("message.loading.places")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityLabel("message.loading.places")
            .accessibilityIdentifier("LoadingProgressView")
    }
    
    var emptyView: some View {
        EmptyStateView()
            .accessibilityIdentifier("EmptyStateView")
    }
    
    func errorView(message: String) -> some View {
        ErrorStateView(message: message) {
            Task {
                await viewModel.loadPlaces()
            }
        }
    }
    
    var mapView: some View {
        PlacesMapView(
            places: viewModel.places,
            customLocation: viewModel.customLocation
        ) { place in
            openWikipedia(for: place)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("PlacesMapView")
    }
    
    var listView: some View {
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
        .accessibilityLabel(LocalizedStrings.locationsCount(viewModel.allPlaces.count))
    }
    
    var refreshButton: some View {
        Button {
            Task {
                await viewModel.loadPlaces()
            }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .accessibilityLabel(LocalizedStrings.accessibilityRefresh)
        .accessibilityHint(LocalizedStrings.accessibilityRefreshHint)
    }
    
    var addCustomLocationButton: some View {
        Button {
            showCustomLocation = true
        } label: {
            Image(systemName: "plus.circle")
                .accessibilityLabel(LocalizedStrings.accessibilityAddCustomLocation)
                .accessibilityHint(LocalizedStrings.accessibilityAddCustomLocationHint)
        }
        .accessibilityIdentifier("AddCustomLocationButton")
    }
}

private extension PlacesListView {
    func openWikipedia(for place: Place) {
        guard let url = place.wikipediaDeepLinkURL else { return }
        
        UIApplication.shared.open(url) { success in
            if !success {
                viewModel.state = .error(ErrorMessages.wikipediaAppNotInstalled)
                showError = true
            }
        }
    }
}

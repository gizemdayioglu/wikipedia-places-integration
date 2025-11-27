import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private let baseURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    
    private lazy var networkService: PlacesNetworkServiceProtocol = {
        PlacesNetworkService(baseURL: baseURL)
    }()
    
    private lazy var placesRepository: PlacesRepositoryProtocol = {
        PlacesRepository(networkService: networkService)
    }()
    
    private lazy var getLocationsUseCase: GetLocationsUseCase = {
        GetLocationsUseCase(repository: placesRepository)
    }()
    
    private lazy var createCustomLocationUseCase: CreateCustomLocationUseCase = {
        CreateCustomLocationUseCase()
    }()
    
    @MainActor
    lazy var placesViewModel: PlacesViewModel = {
        PlacesViewModel(
            getLocationsUseCase: getLocationsUseCase,
            createCustomLocationUseCase: createCustomLocationUseCase
        )
    }()
    
    private init() {}
}

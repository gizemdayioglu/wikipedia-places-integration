import Foundation

@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private lazy var networkService: PlacesNetworkServiceProtocol = {
        PlacesNetworkService()
    }()
    
    private lazy var placesRepository: PlacesRepositoryProtocol = {
        PlacesRepository(networkService: networkService)
    }()
    
    private lazy var getLocationsUseCase: GetLocationsUseCase = {
        GetLocationsUseCase(repository: placesRepository)
    }()
    
    lazy var placesViewModel: PlacesViewModel = {
        PlacesViewModel(getLocationsUseCase: getLocationsUseCase)
    }()
    
    private init() {}
}

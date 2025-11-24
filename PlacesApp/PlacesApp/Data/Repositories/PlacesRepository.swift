import Foundation

final class PlacesRepository: PlacesRepositoryProtocol {
    private let networkService: PlacesNetworkServiceProtocol
    
    init(networkService: PlacesNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getLocations() async throws -> [Place] {
        try await networkService.fetchLocations()
    }
}

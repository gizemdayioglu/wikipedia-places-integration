import Foundation

struct GetLocationsUseCase {
    private let repository: PlacesRepositoryProtocol
    
    init(repository: PlacesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Place] {
        try await repository.getLocations()
    }
}

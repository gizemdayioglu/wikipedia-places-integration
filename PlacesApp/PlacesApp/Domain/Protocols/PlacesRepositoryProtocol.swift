import Foundation

protocol PlacesRepositoryProtocol {
    func getLocations() async throws -> [Place]
}

import Foundation

protocol PlacesNetworkServiceProtocol {
    func fetchLocations() async throws -> [Place]
}

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class PlacesNetworkService: PlacesNetworkServiceProtocol {
    private let decoder = JSONDecoder()
    private let urlSession: URLSessionProtocol
    private let baseURL: String
    private let reachability: NetworkReachabilityProtocol
    
    init(
        baseURL: String,
        urlSession: URLSessionProtocol = URLSession.shared,
        reachability: NetworkReachabilityProtocol = NetworkReachability()
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.reachability = reachability
    }
    
    func fetchLocations() async throws -> [Place] {
        guard reachability.isConnected else {
            throw NetworkError.noConnection
        }
        
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let placesResponse = try decoder.decode(PlacesResponse.self, from: data)
            return placesResponse.locations
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case noConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .decodingError(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .noConnection:
            return NSLocalizedString("error.no.internet.connection", comment: "No internet connection error")
        }
    }
}


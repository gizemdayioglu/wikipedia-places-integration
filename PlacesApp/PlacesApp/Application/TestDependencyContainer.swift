import Foundation

final class UITestMockNetworkReachability: NetworkReachabilityProtocol {
    let isConnected: Bool
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}

final class UITestMockURLSession: URLSessionProtocol {
    let mockData: Data
    
    init(mockData: Data) {
        self.mockData = mockData
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (mockData, response)
    }
}

final class TestDependencyContainer: DependencyContainerProtocol {
    static let shared = TestDependencyContainer()
    
    private let mockData: Data
    private lazy var networkService: PlacesNetworkServiceProtocol = {
        let mockSession = UITestMockURLSession(mockData: mockData)
        return PlacesNetworkService(
            baseURL: "https://www.google.com",
            urlSession: mockSession,
            reachability: UITestMockNetworkReachability(isConnected: true)
        )
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
        let viewModel = PlacesViewModel(
            getLocationsUseCase: getLocationsUseCase,
            createCustomLocationUseCase: createCustomLocationUseCase
        )
        if !ProcessInfo.processInfo.arguments.contains("UITest_ErrorState") {
            Task {
                await viewModel.loadPlaces()
            }
        }
        return viewModel
    }()
    
    private init() {
        let appBundle = Bundle(identifier: "com.places.app") ?? Bundle.main
        if let url = appBundle.url(forResource: "mock_locations", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            self.mockData = data
        } else {
            let fallbackJSON = """
            {
              "locations": [
                {"name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215},
                {"name": "Mumbai", "lat": 19.0823998, "long": 72.8111468},
                {"name": "Copenhagen", "lat": 55.6713442, "long": 12.523785},
                {"lat": 40.4380638, "long": -3.7495758}
              ]
            }
            """
            self.mockData = fallbackJSON.data(using: .utf8) ?? Data()
        }
    }
}


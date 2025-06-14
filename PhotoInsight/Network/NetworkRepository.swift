class NetworkRepository: NetworkRepositoryProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPhotos() async throws -> PhotosResponse {
        return try await networkService.fetchPhotos()
    }
}

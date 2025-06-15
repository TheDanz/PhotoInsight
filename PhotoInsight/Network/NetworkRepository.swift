class NetworkRepository: NetworkRepositoryProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo] {
        return try await networkService.fetchPhotos(page: page, perPage: perPage)
    }
}

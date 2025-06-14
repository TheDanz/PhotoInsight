class NetworkService: BaseNetworkService<PhotoRouter>, NetworkServiceProtocol {
    
    func fetchPhotos() async throws -> [Photo] {
        return try await request([Photo].self, router: .fetch)
    }
}

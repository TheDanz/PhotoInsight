class NetworkService: BaseNetworkService<PhotoRouter>, NetworkServiceProtocol {
    
    func fetchPhotos() async throws -> PhotosResponse {
        return try await request(PhotosResponse.self, router: .fetch)
    }
}

class NetworkService: BaseNetworkService<PhotoRouter>, NetworkServiceProtocol {
    
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo] {
        return try await request([Photo].self, router: .fetch(page: page, perPage: perPage))
    }
}

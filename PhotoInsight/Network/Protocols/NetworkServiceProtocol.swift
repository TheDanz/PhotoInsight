protocol NetworkServiceProtocol {
    func fetchPhotos() async throws -> PhotosResponse
}

protocol NetworkRepositoryProtocol {
    func fetchPhotos() async throws -> PhotosResponse
}

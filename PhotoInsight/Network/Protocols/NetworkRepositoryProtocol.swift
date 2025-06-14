protocol NetworkRepositoryProtocol {
    func fetchPhotos() async throws -> [Photo]
}

protocol NetworkServiceProtocol {
    func fetchPhotos() async throws -> [Photo]
}

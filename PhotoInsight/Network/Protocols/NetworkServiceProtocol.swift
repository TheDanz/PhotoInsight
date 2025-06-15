protocol NetworkServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo]
}

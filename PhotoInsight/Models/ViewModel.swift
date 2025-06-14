import os

final class ViewModel {
    
    private(set) var photos: [Photo] = []
    var onPhotosUpdated: (() -> Void)?
    
    init() { }
    
    func numberOfPhotos() -> Int { photos.count }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetchPhotos() {
        
        let networkService = NetworkRepository(networkService: NetworkService())
        
        Task {
            do {
                let response = try await networkService.fetchPhotos()
                photos.append(contentsOf: response)
                onPhotosUpdated?()
            } catch {
                logger.info("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }
}

private let logger = Logger()


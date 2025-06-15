import os

final class ViewModel {
    
    private(set) var photos: [Photo] = []
    var onPhotosUpdated: (() -> Void)?
    
    private var currentPage: Int = 1
    private let perPage: Int = 10
    private var isPaginating: Bool = false
    
    init() { }
    
    func numberOfPhotos() -> Int { photos.count }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetchInitialPhotos() {
        currentPage = 1
        photos.removeAll()
        fetchPhotos()
    }
    
    func fetchNextPage() {
        guard !isPaginating else { return }
        currentPage += 1
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        isPaginating = true
        let networkService = NetworkRepository(networkService: NetworkService())
        
        Task {
            do {
                let response = try await networkService.fetchPhotos(page: currentPage, perPage: perPage)
                self.photos.append(contentsOf: response)
                self.onPhotosUpdated?()
            } catch {
                logger.info("Error fetching photos: \(error.localizedDescription)")
                self.currentPage -= 1
            }
            self.isPaginating = false
        }
    }
}

private let logger = Logger()


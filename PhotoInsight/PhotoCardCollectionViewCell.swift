import os
import UIKit

class PhotoCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCardCollectionViewCell"

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var imageCache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.layer.cornerRadius = 12
    }
    
    func configure(imageURL: String, numberOfLikes: Int, description: String) {
        
        Task {
            numberOfLikesLabel.text = "\(numberOfLikes)"
            descriptionLabel.text = description
            
            guard let url = URL(string: imageURL) else {
                logger.info("Error handle url for image")
                return
            }
            
            do {
                let image = try await loadImageAsync(url: url)
                pictureImageView.image = image
            } catch {
                logger.info("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadImageAsync(url: URL) async throws -> UIImage {

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
        
        return image
    }
}

private let logger = Logger()

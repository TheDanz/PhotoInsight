import os
import UIKit

final class DetailsViewController: UIViewController {
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Views
    
    lazy var fullPictureImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Inits
    
    init(username: String, imageURL: String) {
        super.init(nibName: nil, bundle: nil)
        
        Task {
            title = username
            
            DispatchQueue.main.async {
                  self.activityIndicator.startAnimating()
            }
            
            guard let url = URL(string: imageURL) else {
                logger.info("Error handle url for image")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            do {
                let image = try await loadImageAsync(url: url)
                DispatchQueue.main.async {
                    self.fullPictureImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                     self.activityIndicator.stopAnimating()
                }
                logger.info("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Load Images
    
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
    
    // MARK: Setup UI
    
    private func setupUI() {
        setupView()
        setupNavigationBar()
        setupFullPictureImageView()
        setupActivityIndicator()
    }
    
    func setupView() {
        view.backgroundColor = .mainBackground
        view.addSubview(fullPictureImageView)
    }
    
    func setupNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = .black
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20)
            ]
        }
    }
    
    private func setupFullPictureImageView() {
        fullPictureImageView.addSubview(activityIndicator)
        fullPictureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        fullPictureImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        fullPictureImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        fullPictureImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator.topAnchor.constraint(equalTo: fullPictureImageView.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: fullPictureImageView.bottomAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: fullPictureImageView.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: fullPictureImageView.trailingAnchor).isActive = true
    }
}

private let logger = Logger()

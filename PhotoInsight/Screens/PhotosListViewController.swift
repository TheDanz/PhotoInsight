import UIKit

final class PhotosListViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    // MARK: - Views
    
    lazy var photoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var dataLoadingIndicatior = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        fetchAndStartAnimatingIndicator()
    }
    
    // MARK: - ViewModel
    
    private func bindViewModel() {
        self.viewModel.onPhotosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadData()
                self?.dataLoadingIndicatior.stopAnimating()
            }
        }
    }
    
    private func fetchAndStartAnimatingIndicator() {
        dataLoadingIndicatior.startAnimating()
        viewModel.fetchPhotos()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupView()
        setupPhotoCollectionView()
        setupDataLoadingIndicatior()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        view.addSubview(photoCollectionView)
    }
    
    private func setupPhotoCollectionView() {
        photoCollectionView.addSubview(dataLoadingIndicatior)
        photoCollectionView.backgroundColor = .mainBackground
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(UINib(nibName: "PhotoCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCardCollectionViewCell.identifier)
        photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    private func setupDataLoadingIndicatior() {
        dataLoadingIndicatior.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dataLoadingIndicatior.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


// MARK: -  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension PhotosListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCardCollectionViewCell.identifier, for: indexPath) as? PhotoCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            imageURL: viewModel.photos[indexPath.row].urls.thumb,
            numberOfLikes: viewModel.photos[indexPath.row].likes,
            description: viewModel.photos[indexPath.row].description ?? viewModel.photos[indexPath.row].altDescription
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 260)
    }
}

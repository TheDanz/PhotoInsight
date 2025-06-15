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
        viewModel.fetchInitialPhotos()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupView()
        setupNavigationBar()
        setupPhotoCollectionView()
        setupDataLoadingIndicatior()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        view.addSubview(photoCollectionView)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .mainBackground
        self.title = "PhotoInsight"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = .clay
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: UIColor.clay
            ]
        }
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
            numberOfLikes: viewModel.photos[indexPath.row].likes ?? 0,
            description: (viewModel.photos[indexPath.row].description ?? viewModel.photos[indexPath.row].altDescription) ?? "No Description",
            colorHex: viewModel.photos[indexPath.row].color ?? "#000000"
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController(
            username: viewModel.photos[indexPath.row].user.username ?? "No Name",
            imageURL: viewModel.photos[indexPath.row].urls.regular
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 260)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (photoCollectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            viewModel.fetchNextPage()
        }
    }
}

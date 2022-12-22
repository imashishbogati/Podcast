//
//  FavoriteViewController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit
import Combine
import SnapKit

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    fileprivate let cellID = "FavoriteCellID"
    
    typealias Factory = FavoriteViewModelFactory
    var factory: Factory
    
    lazy var viewModel = factory.makeFavoriteViewModel()
    
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    fileprivate var podcasts: [Podcast] = []
    
    // MARK: - Methods
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        observeViewModel()
    }
    
    fileprivate func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
    }
    
    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    fileprivate func observeViewModel() {
        viewModel.$podCasts.receive(on: DispatchQueue.main)
            .sink { [weak self] podcasts in
                self?.podcasts = podcasts
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
}


extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FavoriteCollectionViewCell
        cell.artistNameLabel.text = podcasts[indexPath.item].artistName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return .init(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

// MARK: - Protocols
protocol FavoriteViewControllerFactory {
    func makeFavoriteViewController() -> FavoriteViewController
}

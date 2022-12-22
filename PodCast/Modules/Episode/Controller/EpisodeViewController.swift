//
//  EpisodeViewController.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import UIKit
import Combine

class EpisodeViewController: UITableViewController {

    // MARK: - Properties
    private var podCast: Podcast?
    
    fileprivate var episodes: [Episode] = []
    private var subscriptions = Set<AnyCancellable>()
    
    typealias Factory = EpisodeViewModelFactory & PlayerViewFactory
    var factory: Factory
    
    lazy var viewModel = factory.makeEpisodeViewModel(podCast: podCast!)
    
    private let cellID = "episodeCell"
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Methods
    init(style: UITableView.Style = .plain, podCast: Podcast, factory: Factory) {
        self.podCast = podCast
        self.factory = factory
        super.init(style: style)
        viewModel.fetchEpisode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        observeViewModel()
        observeLoadingIndicator()
        observeNavigationTitle()
        setupNavigationLeftButtons()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.addSubview(loadingIndicator)
        loadingIndicator.style = .medium
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(tableView.snp.centerX)
            make.centerY.equalTo(tableView.snp.centerY).offset(-50)
        }
    }
    
    fileprivate func setupNavigationLeftButtons() {
        let favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(didTapSetFavorite))
        navigationItem.setRightBarButton(favoriteButton, animated: true)
        
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.register(EpisodeListTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func observeViewModel() {
        viewModel.$episodes.receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.episodes = response
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    fileprivate func observeLoadingIndicator() {
        viewModel.$showLoadingIndicator.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == true {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func observeNavigationTitle() {
        viewModel.$navigationTitle.receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.navigationItem.title = title
            }.store(in: &subscriptions)
    }
    
    // MARK: - Actions
    @objc
    func didTapSetFavorite() {
        viewModel.persistenceStorage.save(podcast: self.podCast!) { response in
            debugPrint(response)
        }
    }
}

extension EpisodeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeListTableViewCell
        let episode = episodes[indexPath.item]
        cell.selectionStyle = .none
        cell.configureCell(episode: episode, image: podCast?.artworkUrl100 ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.item]
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        if episode.image == nil {
            episode.image = podCast?.artworkUrl100
        }
        let playerView = factory.makePlayerView(episode: episode)
        playerView.frame = tableView.frame
        window?.addSubview(playerView)
    }
    
}

protocol EpisodeViewControllerFactory {
    func makeEpisodeViewController(podCast: Podcast) -> EpisodeViewController
}

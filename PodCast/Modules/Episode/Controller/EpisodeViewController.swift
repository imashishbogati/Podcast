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
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.addSubview(loadingIndicator)
        loadingIndicator.style = .medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -50),
        ])
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.register(EpisodeListTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func observeViewModel() {
        viewModel.$episodes.receive(on: DispatchQueue.main)
            .sink { response in
                self.episodes = response
                self.tableView.reloadData()
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
        var episode = episodes[indexPath.item]
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

//
//  SearchViewController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit
import Combine

class PodcastSearchViewController: UITableViewController {
    
    // MARK: - Properties
    var searchResults: SearchResult?
    
    private let cellID = "podcast"
    
    private let searchController = UISearchController(searchResultsController: nil)
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    typealias Factory = SearchViewModelFactory & EpisodeViewControllerFactory
    var factory: Factory?
    lazy var viewModel = factory?.makeSearchViewModel()
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Methods
    init(style: UITableView.Style = .plain, factory: Factory ) {
        self.factory = factory
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeResults()
        listenForSearchTextChange()
        observeLoadingState()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        setupSearchController()
        tableView.addSubview(loadingIndicator)
        loadingIndicator.style = .medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -150),
        ])
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.register(PodCastListTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.definesPresentationContext = true
    }
    
    fileprivate func observeResults() {
        viewModel?.$results.receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.searchResults = results
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    fileprivate func observeLoadingState() {
        viewModel?.$showLoadingIndicator.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == true {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func listenForSearchTextChange() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map {
            ($0.object as! UISearchTextField).text
        }
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { searchText in
            self.viewModel?.searchPodCast(keyword: searchText ?? "")
        }.store(in: &subscriptions)
    }

}

// MARK: - UITableView
extension PodcastSearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodCastListTableViewCell
        let podCast = searchResults?.results[indexPath.item]
        cell.configureCellData(podCast!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podCast = searchResults?.results[indexPath.item]
        let episodeVC = factory?.makeEpisodeViewController(podCast: podCast!)
        self.navigationController?.pushViewController(episodeVC!, animated: true)
    }
    
}

protocol PodCastSearchViewControllerFactory {
    func makeSearchViewController() -> PodcastSearchViewController
}

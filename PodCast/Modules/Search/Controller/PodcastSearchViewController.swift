//
//  SearchViewController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit
import Combine
import SDWebImage

class PodcastSearchViewController: UITableViewController {
    
    // MARK: - Properties
    var searchResults: SearchResult?
    
    private let cellID = "podcast"
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let viewModel = SearchViewModel(tunesSearchRemoteAPI: ItunesPodCastSearchRemoteAPI(networkManager: PodCastNetworkManager()))
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeResults()
        listenForSearchTextChange()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        setupSearchController()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    fileprivate func observeResults() {
        viewModel.$results.receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.searchResults = results
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    fileprivate func listenForSearchTextChange() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map {
            ($0.object as! UISearchTextField).text
        }
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { searchText in
            self.viewModel.searchPodCast(keyword: searchText ?? "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podCast = searchResults?.results[indexPath.item]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(podCast?.trackName ?? "")\n\(podCast?.artistName ?? "")"
        cell.imageView?.sd_imageTransition = .fade
        cell.imageView?.sd_setImage(with: URL(string: podCast?.artworkUrl100 ?? "")!, placeholderImage: UIImage(named: "appicon"))
        cell.backgroundColor = .clear
        return cell
    }
    
}

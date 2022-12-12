//
//  SearchViewController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit

class PodcastSearchViewController: UITableViewController {
    
    // MARK: - Properties
    let podCasts = [
        Podcast(name: "Let's Build That App", artistName: "Brain Voong"),
        Podcast(name: "Let's Build That App", artistName: "Brain Voong")
    ]
    
    private let cellID = "podcast"
    
    private let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        searchController.searchBar.delegate = self
    }

}

// MARK: - UITableView
extension PodcastSearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podCasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podCast = podCasts[indexPath.item]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(podCast.name)\n\(podCast.artistName)"
        cell.imageView?.image = UIImage(named: "appicon")
        cell.backgroundColor = .clear
        return cell
    }
    
}

// MARK: - SearchBar
extension PodcastSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

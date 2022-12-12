//
//  MainTabBarController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [
            makeNavigationController(with: PodcastSearchViewController(), title: "Search", imageName: "search"),
            makeNavigationController(with: FavoriteViewController(), title: "Favorite", imageName: "favorites"),
            makeNavigationController(with: UIViewController(), title: "Downloads", imageName: "downloads"),
        ]
    }
    
    fileprivate func makeNavigationController(with viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        viewController.navigationItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        return navigationController
    }
}

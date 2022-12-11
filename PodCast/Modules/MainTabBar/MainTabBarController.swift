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
    
    func setupViews() {
        tabBar.tintColor = .purple
        viewControllers = [
            makeNavigationController(viewController: FavoriteViewController(), title: "Favorite", imageName: "favorites"),
            makeNavigationController(viewController: UIViewController(), title: "Search", imageName: "search"),
            makeNavigationController(viewController: UIViewController(), title: "Downloads", imageName: "downloads"),
        ]
    }
    
    private func makeNavigationController(viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        return navigationController
    }
}

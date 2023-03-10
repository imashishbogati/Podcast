//
//  MainTabBarController.swift
//  PodCast
//
//  Created by Ashish Bogati on 11/12/2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    typealias Factory = PodCastSearchViewControllerFactory & FavoriteViewControllerFactory
    
    var factory: Factory?
    
    // ViewControllers
    fileprivate lazy var podCastSearchController = factory!.makeSearchViewController()
    fileprivate lazy var favoriteViewController = factory!.makeFavoriteViewController()
    
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
    }
    
    fileprivate func setupViews() {
        tabBar.tintColor = .purple
        viewControllers = [
            makeNavigationController(with: podCastSearchController, title: "Search", imageName: "search"),
            makeNavigationController(with: favoriteViewController, title: "Favorite", imageName: "favorites"),
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

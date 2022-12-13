//
//  PodCastDependencyContainer.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import Foundation

class PodCastDependencyContainer {
    
    // MARK: - MainTabBar
    func makeMainTabBar() -> MainTabBarController {
        return MainTabBarController(factory: self)
    }
    
    // MARK: - Network Manager
    func makeNetworkManager() -> NetworkManager {
        return PodCastNetworkManager()
    }
    
    // MARK: - SearchPodcastRemoteAPI
    func makeSearchPodCastRemoteAPI() -> SearchPodCastRemoteAPI {
        return ItunesPodCastSearchRemoteAPI(networkManager: makeNetworkManager())
    }
}

// MARK: - Search Podcast
extension PodCastDependencyContainer: PodCastSearchViewControllerFactory {
    func makeSearchViewController() -> PodcastSearchViewController {
        return PodcastSearchViewController(factory: self)
    }
}

extension PodCastDependencyContainer: SearchViewModelFactory {
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(tunesSearchRemoteAPI: makeSearchPodCastRemoteAPI())
    }
}

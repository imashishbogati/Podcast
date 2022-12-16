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
    
    // MARK: - EpisodeRemoteAPI
    func makeEpisodeRemoteAPI() -> EpisodeRemoteAPI {
        return ItunesEpisodeRemoteAPI()
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

// MARK: - Episodes
extension PodCastDependencyContainer: EpisodeViewControllerFactory {
    func makeEpisodeViewController(podCast: Podcast) -> EpisodeViewController {
        return EpisodeViewController(podCast: podCast, factory: self)
    }
}

extension PodCastDependencyContainer: EpisodeViewModelFactory {
    func makeEpisodeViewModel(podCast: Podcast) -> EpisodeViewModel {
        return EpisodeViewModel(itunesEpisodeRemoteAPI: makeEpisodeRemoteAPI(), podCast: podCast)
    }
}

// MARK: - Player View
extension PodCastDependencyContainer: PlayerViewFactory {
    func makePlayerView(episode: Episode) -> PlayerView {
        return PlayerView(episode: episode)
    }
}

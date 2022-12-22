//
//  PodCastDependencyContainer.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import Foundation
import AVFoundation

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
        return EpisodeViewModel(itunesEpisodeRemoteAPI: makeEpisodeRemoteAPI(), podCast: podCast, persistenceStorage: makeFavoritePodcastPersistence())
    }
}

// MARK: - Player View
extension PodCastDependencyContainer: PlayerViewFactory {
    func makePlayerView(episode: Episode) -> PlayerView {
        return PlayerView(episode: episode, factory: self)
    }
}

extension PodCastDependencyContainer: PlayerViewModelFactory {
    func makePlayerViewModel() -> PlayerViewModel {
        return PlayerViewModel()
    }
}

// MARK: - Player Control
extension PodCastDependencyContainer: PlayerControlViewFactory {
    func makePlayerControl(player: AVPlayer) -> PlayerControlView {
        return PlayerControlView(viewModel: makePlayerControlViewModel(player: player))
    }
}

extension PodCastDependencyContainer: PlayerControlViewModelFactory {
    func makePlayerControlViewModel(player: AVPlayer) -> PlayerControlViewModel {
        return PlayerControlViewModel(player: player)
    }
}

// MARK: - Sound Control
extension PodCastDependencyContainer: SoundControlViewFactory {
    func makeSoundControlView(player: AVPlayer) -> SoundControlView {
        return SoundControlView(viewModel: makeSoundControlViewModel(player: player))
    }
}

extension PodCastDependencyContainer: SoundControlViewModelFactory {
    func makeSoundControlViewModel(player: AVPlayer) -> SoundControlViewModel {
        return SoundControlViewModel(player: player)
    }
}

// MARK: - Audio Slider
extension PodCastDependencyContainer: AudioSliderViewFactory {
    func makeAudioSliderFactory(player: AVPlayer) -> AudioSliderView {
        return AudioSliderView(viewModel: makeAudioSliderViewModel(player: player))
    }
}

extension PodCastDependencyContainer: AudioSliderViewModelFactory {
    func makeAudioSliderViewModel(player: AVPlayer) -> AudioSliderViewModel {
        return AudioSliderViewModel(player: player)
    }
}


// MARK: - FavoriteViewController
extension PodCastDependencyContainer: FavoriteViewControllerFactory {
    func makeFavoriteViewController() -> FavoriteViewController {
        return FavoriteViewController(factory: self)
    }
}

extension PodCastDependencyContainer: FavoriteViewModelFactory {
    func makeFavoriteViewModel() -> FavoriteViewModel {
        return FavoriteViewModel(localDataStore: makeFavoritePodcastPersistence())
    }
}

extension PodCastDependencyContainer: FavoritePodcastPersistenceFactory {
    func makeFavoritePodcastPersistence() -> PodCastPersistence {
        return FavoritePodcastPersistence(episodePersistence: makePropertyListCoder())
    }
}

extension PodCastDependencyContainer: FavoritePodCastPropertyListCoderFactory {
    func makePropertyListCoder() -> FavoritePodcastCoding {
        return FavoritePodCastPropertyListCoder()
    }
}



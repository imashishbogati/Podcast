//
//  PodCastDependencyContainer.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import Foundation
import AVKit

class PodCastDependencyContainer {
    
    // MARK: - Longed Lived Dependency
    lazy var avPlayer: AVPlayer = makeAVPlayer()
    
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
    
    // MARK: - AVPlayer
    func makeAVPlayer() -> AVPlayer {
        return AVPlayer()
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
        return PlayerView(episode: episode, factory: self)
    }
}

extension PodCastDependencyContainer: PlayerViewModelFactory {
    func makePlayerViewModel() -> PlayerViewModel {
        return PlayerViewModel(player: avPlayer)
    }
}

// MARK: - Player Control
extension PodCastDependencyContainer: PlayerControlViewFactory {
    func makePlayerControl() -> PlayerControlView {
        return PlayerControlView(factory: self)
    }
}

extension PodCastDependencyContainer: PlayerControlViewModelFactory {
    func makePlayerControlViewModel() -> PlayerControlViewModel {
        return PlayerControlViewModel(player: avPlayer)
    }
}

// MARK: - Sound Control
extension PodCastDependencyContainer: SoundControlViewFactory {
    func makeSoundControlView() -> SoundControlView {
        return SoundControlView(viewModel: makeSoundControlViewModel())
    }
}

extension PodCastDependencyContainer: SoundControlViewModelFactory {
    func makeSoundControlViewModel() -> SoundControlViewModel {
        return SoundControlViewModel(player: avPlayer)
    }
}

// MARK: - Audio Slider
extension PodCastDependencyContainer: AudioSliderViewFactory {
    func makeAudioSliderFactory() -> AudioSliderView {
        return AudioSliderView(viewModel: makeAudioSliderViewModel())
    }
}

extension PodCastDependencyContainer: AudioSliderViewModelFactory {
    func makeAudioSliderViewModel() -> AudioSliderViewModel {
        return AudioSliderViewModel(player: avPlayer)
    }
}

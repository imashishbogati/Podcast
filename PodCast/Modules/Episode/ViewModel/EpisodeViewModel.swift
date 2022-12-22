//
//  EpisodeViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import Foundation
import Combine

class EpisodeViewModel {
    
    // MARK: - Properties
    var itunesEpisodeRemoteAPI: EpisodeRemoteAPI
    var persistenceStorage: PodCastPersistence
    var podCast: Podcast
    
    @Published var episodes: [Episode] = []
    @Published var showLoadingIndicator: Bool = true
    @Published var navigationTitle = ""
    
    // MARK: - Methods
    init(itunesEpisodeRemoteAPI: EpisodeRemoteAPI, podCast: Podcast, persistenceStorage: PodCastPersistence) {
        self.podCast = podCast
        self.persistenceStorage = persistenceStorage
        self.itunesEpisodeRemoteAPI = itunesEpisodeRemoteAPI
        self.navigationTitle = podCast.trackName ?? "No title"
    }
    
    func fetchEpisode() {
        showLoadingIndicator = true
        guard let feedItem = podCast.feedUrl else {
            showLoadingIndicator = false
            return
        }
        
        guard feedItem != "" else {
            showLoadingIndicator = false
            return
        }
        
        itunesEpisodeRemoteAPI.fetchEpisode(urlString: feedItem) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showLoadingIndicator = false
            switch response {
            case .success(let data):
                strongSelf.episodes = data
            case .failure(let failure):
                debugPrint(failure)
            }
        }
    }
    
}

// MARK: - Protocol
protocol EpisodeViewModelFactory {
    func makeEpisodeViewModel(podCast: Podcast) -> EpisodeViewModel
}

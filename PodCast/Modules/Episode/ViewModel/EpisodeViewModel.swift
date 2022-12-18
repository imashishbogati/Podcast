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
    var podCast: Podcast
    
    @Published var episodes: [Episode] = []
    @Published var showLoadingIndicator: Bool = true
    @Published var navigationTitle = ""
    
    // MARK: - Methods
    init(itunesEpisodeRemoteAPI: EpisodeRemoteAPI, podCast: Podcast) {
        self.podCast = podCast
        self.itunesEpisodeRemoteAPI = itunesEpisodeRemoteAPI
        self.navigationTitle = podCast.trackName ?? "No title"
        DispatchQueue.global(qos: .background).async {
            self.fetchEpisode()
        }
    }
    
    func fetchEpisode() {
        showLoadingIndicator = true
        guard let feedItem = podCast.feedUrl else {
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

protocol EpisodeViewModelFactory {
    func makeEpisodeViewModel(podCast: Podcast) -> EpisodeViewModel
}

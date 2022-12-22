//
//  FavoriteViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import Foundation
import Combine

class FavoriteViewModel {
    
    @Published var podCasts: [Podcast] = []
    var localPersistence: PodCastPersistence
    
    // MARK: - Methods
    init(localDataStore: PodCastPersistence) {
        self.localPersistence = localDataStore
        fetchEpisodes()
    }
    
    fileprivate func fetchEpisodes() {
        localPersistence.fetch { [weak self] response in
            switch response {
            case .success(let podCast):
                self?.podCasts = podCast
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: - Protocols
protocol FavoriteViewModelFactory {
    func makeFavoriteViewModel() -> FavoriteViewModel
}

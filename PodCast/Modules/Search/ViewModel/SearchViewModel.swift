//
//  SearchViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation
import Combine

class SearchViewModel {
    
    // MARK: - Properties
    var itunesSearchRemoteAPI: SearchPodCastRemoteAPI
    @Published var results: SearchResult?
    @Published var showLoadingIndicator: Bool = false
    
    // MARK: - Methods
    init(tunesSearchRemoteAPI: SearchPodCastRemoteAPI) {
        self.itunesSearchRemoteAPI = tunesSearchRemoteAPI
    }
    
    func searchPodCast(keyword: String) {
        showLoadingIndicator = true
        
        guard keyword != "" else {
            results = nil
            showLoadingIndicator = false
            return
        }
        
        itunesSearchRemoteAPI.executeSearch(keyWord: keyword) { response in
            self.showLoadingIndicator = false
            switch response {
            case .success(let success):
                self.results = success
            case .failure(let failure):
                debugPrint(failure)
            }
        }
    }
}

protocol SearchViewModelFactory {
    func makeSearchViewModel() -> SearchViewModel
}

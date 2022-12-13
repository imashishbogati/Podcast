//
//  SearchViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation
import Combine

class SearchViewModel {
    
    @Published var results: SearchResult?
    var itunesSearchRemoteAPI: SearchPodCastRemoteAPI
    
    init(tunesSearchRemoteAPI: SearchPodCastRemoteAPI) {
        self.itunesSearchRemoteAPI = tunesSearchRemoteAPI
    }
    
    func searchPodCast(keyword: String) {
        itunesSearchRemoteAPI.executeSearch(keyWord: keyword) { response in
            switch response {
            case .success(let success):
                self.results = success
            case .failure(let failure):
                debugPrint(failure)
            }
        }
    }
}

//
//  SearchPodCastRemoteAPI.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

protocol SearchPodCastRemoteAPI {
    func executeSearch(keyWord: String, completion: @escaping (Result<SearchResult, Error>) -> Void)
}

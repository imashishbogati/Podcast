//
//  ItunesPodCastSearchRemoteAPI.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

class ItunesPodCastSearchRemoteAPI: SearchPodCastRemoteAPI {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func executeSearch(keyWord: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://itunes.apple.com/search?term=\(keyWord)")!)
        urlRequest.httpMethod = "GET"
        
        networkManager.loadData(urlRequest) { response in
            switch response {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(RemoteAPIError.noData))
                    return
                }
                do {
                    let results = try JSONDecoder().decode(SearchResult.self, from: data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

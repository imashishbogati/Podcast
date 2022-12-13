//
//  PodCastNetworkManager.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

class PodCastNetworkManager: NetworkManager {
    
    func loadData(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RemoteAPIError.httpError))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(RemoteAPIError.httpError))
                return
            }
            
            guard let data = data else {
                completion(.failure(RemoteAPIError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

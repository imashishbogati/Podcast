//
//  NetworkManager .swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

protocol NetworkManager {
    func loadData(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void)
}

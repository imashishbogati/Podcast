//
//  EpisodeRemoteAPI.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import Foundation

protocol EpisodeRemoteAPI {
    func fetchEpisode(urlString: String, completion: @escaping (Result<[Episode], Error>) -> Void)
}

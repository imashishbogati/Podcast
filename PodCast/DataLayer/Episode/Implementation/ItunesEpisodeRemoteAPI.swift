//
//  ItunesEpisodeRemoteAPI.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import Foundation
import FeedKit

class ItunesEpisodeRemoteAPI: EpisodeRemoteAPI {
    
    func fetchEpisode(urlString: String, completion: @escaping (Result<[Episode], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let parser = FeedParser(URL: url)
        
        parser.parseAsync { result in
            switch result {
            case .success(let success):
                switch success {
                case let .rss(feed):
                    var episodes: [Episode] = []
                    feed.items?.forEach({ feedItem in
                        let episode = Episode(title: feedItem.title, lastBuildDate: "\(String(describing: feedItem.pubDate))", image: "")
                        episodes.append(episode)
                    })
                    completion(.success(episodes))
                default:
                    break
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    
}

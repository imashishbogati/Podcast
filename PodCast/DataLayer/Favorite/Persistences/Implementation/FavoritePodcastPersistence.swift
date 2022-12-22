//
//  FavoriteEpisodePersistence.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import Foundation

class FavoritePodcastPersistence: PodCastPersistence {
    
    fileprivate var userDefault = UserDefaults()
    fileprivate let key = "FavoritePodcast"
    
    var podcastPersistence: FavoritePodcastCoding
    
    init(episodePersistence: FavoritePodcastCoding) {
        self.podcastPersistence = episodePersistence
    }
    
    func save(podcast: Podcast) {
        if let data = userDefault.object(forKey: key) as? Data {
            var podcasts = podcastPersistence.decode(data: data)
            if podcasts.contains(podcast) {
                return
            }
            podcasts.append(podcast)
            let encode = podcastPersistence.encode(podcast: podcasts)
            userDefault.set(encode, forKey: key)
        } else {
            let encode = podcastPersistence.encode(podcast: [podcast])
            userDefault.set(encode, forKey: key)
        }
    }
    
    func fetch(completion: @escaping (Result<[Podcast], Error>) -> Void) {
        if let data = userDefault.object(forKey: key) as? Data {
            let episodes = podcastPersistence.decode(data: data)
            completion(.success(episodes))
        } else {
            completion(.success([]))
        }
    }
    
    func delete(podcast: Podcast) {
        if let data = userDefault.object(forKey: key) as? Data {
            var podcasts = podcastPersistence.decode(data: data)
            for (index, item) in podcasts.enumerated() {
                if item.artistName == podcast.artistName {
                    podcasts.remove(at: index)
                }
            }
            let encode = podcastPersistence.encode(podcast: podcasts)
            userDefault.set(encode, forKey: key)
        }
    }
    
}

// MARK: - Protocols
protocol FavoritePodcastPersistenceFactory {
    func makeFavoritePodcastPersistence() -> PodCastPersistence
}

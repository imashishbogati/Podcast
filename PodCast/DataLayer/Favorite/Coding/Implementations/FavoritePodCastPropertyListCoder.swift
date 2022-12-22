//
//  FavoriteEpisodePropertyListCoder.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import Foundation

class FavoritePodCastPropertyListCoder: FavoritePodcastCoding {
    
    // MARK: - Methods
    func encode(podcast: [Podcast]) -> Data {
        return try! PropertyListEncoder().encode(podcast)
    }
    
    func decode(data: Data) -> [Podcast] {
        return try! PropertyListDecoder().decode([Podcast].self, from: data)
    }
}

protocol FavoritePodCastPropertyListCoderFactory {
    func makePropertyListCoder() -> FavoritePodcastCoding
}

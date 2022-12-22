//
//  FavoriteEpisodeCoding.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import Foundation

protocol FavoritePodcastCoding {
    func encode(podcast: [Podcast]) -> Data
    func decode(data: Data) -> [Podcast]
}

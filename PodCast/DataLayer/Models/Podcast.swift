//
//  Podcast.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

struct Podcast: Decodable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let trackCount: Int?
    let kind: String?
}

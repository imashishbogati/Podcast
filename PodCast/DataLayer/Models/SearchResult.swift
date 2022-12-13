//
//  SearchResult.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}

//
//  Episode.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import Foundation
import FeedKit

class Episode {
    let title: String?
    let lastBuildDate: Date?
    var image: String?
    let descriptions: String?
    let author: String?
    let streamURL: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title
        self.lastBuildDate = feedItem.pubDate
        self.image = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? "No Author"
        self.streamURL = feedItem.enclosure?.attributes?.url ?? ""
        self.descriptions = feedItem.description
    }
}

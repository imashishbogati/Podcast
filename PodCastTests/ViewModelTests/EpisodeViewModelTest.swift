//
//  EpisodeViewModelTest.swift
//  PodCastTests
//
//  Created by Ashish Bogati on 22/12/2022.
//

import XCTest
@testable import PodCast
@testable import FeedKit

final class EpisodeViewModelTest: XCTestCase {
    
    func test_navigationTitleProperties_shouldBeEqualAsTrackName() {
        let remoteAPI = MockEpisodeRemoteAPI()
        let sut = makeSut(remoteAPI: remoteAPI)
        XCTAssertEqual(sut.navigationTitle, "DUMMY TrackName")
    }
    
    func test_FetchEpisode_shouldCallToNetwork() {
        let remoteAPI = MockEpisodeRemoteAPI()
        let sut = makeSut(remoteAPI: remoteAPI)
        sut.fetchEpisode()
        XCTAssertEqual(remoteAPI.callCount, 1)
    }
    
    func test_FetchEpisode_withEmptyFeedURL_shouldNotCallToNetwork() {
        let remoteAPI = MockEpisodeRemoteAPI()
        let podCast = makePodCast(feedURL: "")
        let sut = makeSut(remoteAPI: remoteAPI, podCast: podCast)
        sut.fetchEpisode()
        XCTAssertEqual(remoteAPI.callCount, 0)
        XCTAssertEqual(sut.showLoadingIndicator, false)
    }
    
    func test_FetchEpisode_withValidResponse() {
        let remoteAPI = MockEpisodeRemoteAPI()
        let expectation = expectation(
            description: "fetches data and updates results properties."
        )
        remoteAPI.isValidResponse = true
        let sut = makeSut(remoteAPI: remoteAPI)
        sut.fetchEpisode()
        XCTAssertEqual(sut.showLoadingIndicator, true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(sut.showLoadingIndicator, false)
            XCTAssertEqual(sut.episodes.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_savePodcast_shouldSavePodcast() {
        let remoteAPI = MockEpisodeRemoteAPI()
        let podCast = makePodCast(feedURL: "")
        let persistence = MockPodCastPersistence()
        let sut = makeSut(remoteAPI: remoteAPI, podCast: podCast, persistence: persistence)
        sut.toggleFavorite()
        XCTAssertEqual(sut.isFavorite, true)
        sut.toggleFavorite()
        XCTAssertEqual(sut.isFavorite, false)
    }
}

fileprivate func makePodCast(feedURL: String = "test") -> Podcast {
    return Podcast(trackName: "DUMMY TrackName",
                   artistName: "DUMMY ArtistName",
                   artworkUrl100: "DUMMY",
                   trackCount: 1,
                   kind: "podcast",
                   feedUrl: feedURL)
}

fileprivate func makeEpisodeResponse() -> Episode {
    let rssFeedItem = RSSFeedItem()
    rssFeedItem.author = "DUMMY Author"
    rssFeedItem.title = "DUMMY TITLE"
    return Episode(feedItem: rssFeedItem)
}

fileprivate func makeSut(remoteAPI: EpisodeRemoteAPI, podCast: Podcast = makePodCast(), persistence: PodCastPersistence = MockPodCastPersistence()) -> EpisodeViewModel {
    return EpisodeViewModel(itunesEpisodeRemoteAPI: remoteAPI, podCast: podCast, persistenceStorage: persistence)
}

class MockEpisodeRemoteAPI: EpisodeRemoteAPI {
    
    var isValidResponse: Bool = false
    
    var callCount = 0
    
    func fetchEpisode(urlString: String, completion: @escaping (Result<[Episode], Error>) -> Void) {
        callCount += 1
        
        if isValidResponse {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(.success([makeEpisodeResponse()]))
            }
        }
    }
    
}

class MockPodCastPersistence: PodCastPersistence {
    var podCasts: [Podcast] = []
    
    func save(podcast: Podcast) {
        podCasts.append(podcast)
    }
    
    func fetch(completion: @escaping (Result<[Podcast], Error>) -> Void) {
        completion(.success(podCasts))
    }
    
    func delete(podcast: Podcast) {
        for (index, item) in podCasts.enumerated() {
            if item.trackName == podcast.trackName {
                podCasts.remove(at: index)
            }
        }
    }
}

//
//  SearchViewModelTests.swift
//  PodCastTests
//
//  Created by Ashish Bogati on 22/12/2022.
//

import XCTest
@testable import PodCast

final class SearchViewModelTests: XCTestCase {
    func test_searchPodCast_withEmptyString_shouldNotRequestToNetwork() {
        let remoteAPI = MockSearchPodCastRemoteAPI()
        let sut = makeSut(remoteAPI: remoteAPI)
        sut.searchPodCast(keyword: "")
        XCTAssertEqual(remoteAPI.callCount, 0)
    }
    
    func test_searchPodCast_withKeyWord_shouldRequestToNetwork() {
        let remoteAPI = MockSearchPodCastRemoteAPI()
        let sut = makeSut(remoteAPI: remoteAPI)
        sut.searchPodCast(keyword: "DUMMY")
        XCTAssertEqual(remoteAPI.callCount, 1)
    }
    
    func test_searchPodCast_withValidKeyWordAndValidResponse_resultsShouldNotBeNil() {
        let remoteAPI = MockSearchPodCastRemoteAPI()
        let expectation = XCTestExpectation(
          description: "fetches data and updates results properties."
        )
        remoteAPI.isValidRequest = true
        let sut = makeSut(remoteAPI: remoteAPI)
        sut.searchPodCast(keyword: "DUMMY")
        XCTAssertEqual(sut.showLoadingIndicator, true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(sut.results?.resultCount, 1)
            XCTAssertEqual(sut.showLoadingIndicator, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}

fileprivate func makeSut(remoteAPI: SearchPodCastRemoteAPI) -> SearchViewModel {
    return SearchViewModel(tunesSearchRemoteAPI: remoteAPI)
}

class MockSearchPodCastRemoteAPI: SearchPodCastRemoteAPI {
    var isValidRequest: Bool = false
    var callCount = 0
    
    func executeSearch(keyWord: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        callCount += 1
        if isValidRequest {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(SearchResult(resultCount: 1,
                                                 results: [])))
            }
            
        }
    }
}

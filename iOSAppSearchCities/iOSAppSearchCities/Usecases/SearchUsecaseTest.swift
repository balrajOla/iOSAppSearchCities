//
//  SearchUsecaseTest.swift
//  iOSAppSearchCitiesTests
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest
@testable import iOSAppSearchCities

class SearchUsecaseTest: XCTestCase {

    func test_SearchForKey() {
        _ = IndexingUsecase.sharedInstance.indexing()
        let sut = SearchUsecase(service: Service(indexes: Indexes(for: FACache.citiesIndexesKey)))
        let testData = self.searchTestData()
        
        let expectation = self.expectation(description: "Searching")
        var searchResult: String? = nil
        
        sut.search(byKeyword: testData.0)
            .observe {
                switch $0 {
                case .success(let value):
                    searchResult = value.info.first?.detail.name
                case .failure(_ ):
                   break
                }
                
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual((searchResult ?? ""), testData.1, "Search result is not as per expectation")
    }

    private func searchTestData() -> (String, String) {
        return ("Hurzuf", "Hurzuf")
    }
}

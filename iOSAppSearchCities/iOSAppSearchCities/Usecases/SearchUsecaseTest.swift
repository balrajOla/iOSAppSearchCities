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
    
    override func setUp() {
        _ = IndexingUsecase.sharedInstance.indexing()
    }

    func test_SearchForKey() {
        sleep(5)  // This sleep is to provide some head start for indexing to kick in with some data
        
        let sut = SearchUsecase(service: Service(indexes: Indexes(for: FACache.citiesIndexesKey)))
        let testData = self.searchTestData()
        
        let expectation = self.expectation(description: "Searching")
        var searchResult: [(String, String)] = [(String, String)]()
        let totalTestDataCount = testData.count
        var totalResponsesRecieved = 0
        
        testData.forEach { key in
            sut.search(byKeyword: key.0)
                .observe {
                    switch $0 {
                    case .success(let value):
                        searchResult.append((key.0, value.1.info.first?.detail.name.lowercased() ?? ""))
                    case .failure(_ ):
                         searchResult.append((key.0, ""))
                    }
                    
                    totalResponsesRecieved = totalResponsesRecieved + 1
                    
                    if totalTestDataCount == totalResponsesRecieved {
                        expectation.fulfill()
                    }
            }
            
            sleep(1) // This to handle debounce scenario
        }
        
        wait(for: [expectation], timeout: 60)
        
        XCTAssertEqual(testData.count, searchResult.count, "Search result count should be equal")
        
        
        
        // compare two data response by response
        searchResult = searchResult.sorted(by: { $0.0 < $1.1 })
        let requestedData = testData.sorted(by: { $0.0 < $1.1 })
        
        let expectationCompareResult = self.expectation(description: "Comparing result")
        totalResponsesRecieved = 1
        
        for i in Array(1..<totalTestDataCount) {
            totalResponsesRecieved = totalResponsesRecieved + 1
            XCTAssertEqual(requestedData[i].1, searchResult[i].1, "Search result count should be equal")
            
            if totalTestDataCount == totalResponsesRecieved {
                expectationCompareResult.fulfill()
            }
        }
        
        wait(for: [expectationCompareResult], timeout: 60)
    }

    private func searchTestData() -> [(String, String)] {
        return [("hurzuf".lowercased(), "hurzuf".lowercased()),
        ("Novinki".lowercased(), "Novinki".lowercased()),
        ("Gorkhā".lowercased(), "Gorkhā".lowercased()),
        ("zzzz".lowercased(), "".lowercased()),
        ("Holubynka".lowercased(), "Holubynka".lowercased()),
        ("aaaaa".lowercased(), "".lowercased())]
    }
}

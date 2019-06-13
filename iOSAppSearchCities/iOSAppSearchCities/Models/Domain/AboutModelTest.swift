//
//  AboutModelTest.swift
//  iOSAppSearchCitiesTests
//
//  Created by Balraj Singh on 13/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest
@testable import iOSAppSearchCities

class AboutModelTest: XCTestCase {

    func test_AboutModel_PresenterSuccessInfoLoadedCalled() {
        let mockPresenter = MockPresenter()
        
        let aboutModel = Model()
        aboutModel.aboutInfo = self.getMockAboutInfo()
        
        aboutModel.loadAboutInfo(with: mockPresenter)
        
        let expectation = self.expectation(description: "aboutInfoDidCalled")
        DispatchQueue.main.async {
            XCTAssert(mockPresenter.aboutInfoDidCalled, "AboutInfoDidLoad should be called successfully")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_AboutModel_PresenterFailureToLoadAboutInfoCalled() {
        let mockPresenter = MockPresenter()
        
        let aboutModel = Model()
        
        aboutModel.loadAboutInfo(with: mockPresenter)
        
        XCTAssert(mockPresenter.aboutInfoDidFailLoadingCalled, "AboutInfoDidFailLoading should be called successfully")
    }
    
    private func getMockAboutInfo() -> AboutInfo {
        return AboutInfo(country: "SampleCountry", city: "SampleCity", lat: "1.1", long: "1.1")
    }
}

class MockPresenter: AboutPresenter {
    var loadAboutInfoCalled: Bool = false
    var aboutInfoDidCalled: Bool = false
    var aboutInfoDidFailLoadingCalled: Bool = false
    
    func loadAboutInfo() {
        self.loadAboutInfoCalled = true
    }
    
    func aboutInfoDidLoad(aboutInfo: AboutInfoData) {
        self.aboutInfoDidCalled = true
    }
    
    func aboutInfoDidFailLoading(error: ModelError) {
        self.aboutInfoDidFailLoadingCalled = true
    }
}


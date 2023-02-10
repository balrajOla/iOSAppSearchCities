//
//  AboutPresenterTest.swift
//  iOSAppSearchCitiesTests
//
//  Created by Balraj Singh on 13/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest
@testable import iOSAppSearchCities

class AboutPresenterTest: XCTestCase {

    func test_AboutPresenter_loadAboutInfoCalled() {
        let mockAboutModel = MockAboutModel()
        let mockAboutView = MockAboutView()
        
        let sut = Presenter(view: mockAboutView, model: mockAboutModel)
        sut.loadAboutInfo()
        
        XCTAssertTrue(mockAboutView.setActivityCalled, "Activity indicator is set")
        XCTAssertTrue(mockAboutModel.loadAboutInfoCalled, "loadAboutInfo is called")
    }
    
    func test_AboutPresenter_AboutInfoDidFailLoadingCalled() {
        let mockAboutModel = MockAboutModel()
        let mockAboutView = MockAboutView()
        
        let sut = Presenter(view: mockAboutView, model: mockAboutModel)
        sut.aboutInfoDidFailLoading(error: ModelError.failedLoading)
        
        XCTAssertTrue(mockAboutView.setActivityCalled, "Activity indicator is set")
        XCTAssertTrue(mockAboutView.displayErrorCalled, "displayErrorCalled is called")
    }
    
    func test_AboutPresenter_aboutInfoDidLoadCalled() {
        let mockAboutModel = MockAboutModel()
        let mockAboutView = MockAboutView()
        
        let sut = Presenter(view: mockAboutView, model: mockAboutModel)
        sut.aboutInfoDidLoad(aboutInfo: getAboutInfo())
        
        XCTAssertTrue(mockAboutView.setActivityCalled, "Activity indicator is set")
        XCTAssertTrue(mockAboutView.configuredCalled, "configured is called")
    }
    
    private func getAboutInfo() -> AboutInfo {
        return AboutInfo(country: "SampleCountry", city: "SampleCity", lat: "1.1", long: "1.0")
    }
}

class MockAboutModel: AboutModel {
    var aboutInfo: AboutInfo?
    var loadAboutInfoCalled: Bool = false
    
    func loadAboutInfo(with presenter: AboutPresenter) {
        self.loadAboutInfoCalled = true
    }
}

class MockAboutView: AboutView {
    var configuredCalled = false
    var displayErrorCalled = false
    var setActivityCalled = false
    
    func configure(with aboutInfo: AboutInfoData) {
        configuredCalled = true
    }
    
    func display(error: ModelError) {
        displayErrorCalled = true
    }
    
    func setActivityIndicator(hidden: Bool) {
        setActivityCalled = true
    }
}

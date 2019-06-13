//
//  AboutViewUITest.swift
//  iOSAppSearchCitiesUITests
//
//  Created by Balraj Singh on 13/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest

class AboutViewUITest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_AboutView_InfoPresent() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        sleep(2) // This is to initiate indexing for new app launch
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        // enter search text
        let searchBar = XCUIApplication().otherElements["search_keyword"]
        searchBar.tap()
        sleep(2)
        searchBar.typeText("Hurzuf")
        
        // wait for search result to appear
        sleep(2)
        
        // select the response from the table
        tablesQuery.staticTexts["City: Hurzuf, "].tap()
        
        // select the info buttomn from Map screen
        app.navigationBars["Hurzuf"].buttons["Info"].tap()
        
        // Check if all the elements exists
        XCTAssertTrue(tablesQuery.staticTexts["Hurzuf"].exists, "Name Hurzuf should exists")
        XCTAssertTrue(tablesQuery.staticTexts["UA"].exists, "Country name should exists")
        XCTAssertTrue(tablesQuery.staticTexts["44.549999"].exists, "Lat should exists")
        XCTAssertTrue(tablesQuery.staticTexts["34.283333"].exists, "Long should exists")
    }

}

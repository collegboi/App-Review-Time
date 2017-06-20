//
//  AppReviewTimeTests.swift
//  AppReviewTimeTests
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import XCTest

class AppReviewTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let appViewController = AppViewController()
        appViewController.scrapeAppReviewTime(for: .iosRaw) { (complete, data) in
            if complete {
                let returnData = appViewController.parseHTMLRawData(html: data)
                print(returnData)
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

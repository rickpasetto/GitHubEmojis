//
//  GitHubEmojisTests.swift
//  GitHubEmojisTests
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation
import XCTest
@testable import GitHubEmojis

class GitHubEmojisTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testExample() {

        let bundleUrl = Bundle(for: GitHubEmojisTests.self).bundleURL.appendingPathComponent("emojis.json")

        let fetcher = Fetcher(url: bundleUrl)
        
        let expectation = self.expectation(description: "Successful fetch")
        
        fetcher.fetch(handler: (
            onFetchComplete: { emojis in
                print("SUCCESS: " + emojis.description)
                expectation.fulfill()
            },
            onFetchError: { error in
                print("FAIL: \(error)")
                expectation.fulfill()
        }
        ))
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

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
    
    let GitHubURL = URL(string: "https://api.github.com/emojis")!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLocalFetch() {
        
        let bundleUrl = Bundle(for: GitHubEmojisTests.self).bundleURL.appendingPathComponent("emojis.json")
        
        let fetcher = URLFetcher(url: bundleUrl)
        
        let expectation = self.expectation(description: "Successful fetch")
        
        fetcher.fetch((
            onFetchComplete: { data in
                XCTAssertGreaterThan(data.count, 0)
                expectation.fulfill()
        },
            onFetchError: { error in
                XCTFail("\(error)")
                expectation.fulfill()
        }
        ))
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testModel() {

        var count = -1
        let testFetcher = TestFetcher()
        let model = Model(fetcher: testFetcher)

        model.refreshData(
            dataReady: {
                count = model.count
        },
            dataError: { error in
        })

        let bundleUrl = Bundle(for: GitHubEmojisTests.self).bundleURL.appendingPathComponent("emojis.json")
        let data = NSData(contentsOf: bundleUrl)

        testFetcher.handler?.onFetchComplete(data as! Data)

        XCTAssertGreaterThan(count, 0)
    }

    // TODO: Write test for URLImageLoader
}

class TestFetcher: Fetcher {

    var handler: ResponseHandler?

    func fetch(_ handler: ResponseHandler) {
        self.handler = handler
    }

    func cancel() {
    }
}

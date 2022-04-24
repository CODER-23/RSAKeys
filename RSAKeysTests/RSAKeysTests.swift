//
//  RSAKeysTests.swift
//  RSAKeysTests
//
//  Created by Krish Kharbanda on 4/19/22.
//

import XCTest
@testable import RSAKeys

class RSAKeysTests: XCTestCase {

    var keys: Keys!
    
    override func setUpWithError() throws {
        keys = Keys()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print(keys.getPublicKeyAsString() ?? "")
        print(keys.encrypt("I love RSAKeys!") ?? "")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

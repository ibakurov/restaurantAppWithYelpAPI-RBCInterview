//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Tests that conversion between string and date are working
    func testDateConversion() {
        let now = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let nowInString = Date.convertDateToStringDate(date: now, dateFormatToString: Review.Constants.dateFormat)
        XCTAssertNotNil(nowInString)
        
        let backToNow = Date.convertStringDateToDate(dateInString: nowInString!, dateFormatInString: Review.Constants.dateFormat)
        XCTAssertNotNil(backToNow)
    }
    
}

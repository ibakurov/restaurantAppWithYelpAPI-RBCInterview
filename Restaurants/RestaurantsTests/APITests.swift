//
//  APITests.swift
//  RestaurantsTests
//
//  Created by Illya Bakurov on 10/2/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import XCTest
@testable import Restaurants

class APITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Tests that Yelp API is up and running, by returning any results to search request
    func testSearchAPI() {
        RARRestaurantAPI.shared.fetchRestauraunts(keyword: "Starbucks", latitude: 43.646210, longitude: -79.379539, offset: 0, limit: 10, success: { restaurants, _ in
            XCTAssert(restaurants.count > 0)
        })
    }
    
    func testBusinessDetailsAPI() {
        RARRestaurantAPI.shared.fetchRestauraunts(keyword: "Starbucks", latitude: 43.646210, longitude: -79.379539, offset: 0, limit: 10, success: { restaurants, _ in
            XCTAssert(restaurants.count > 0)
            if let restaurant = restaurants.first, let id = restaurant.id {
                RARRestaurantAPI.shared.fetchDetails(forRestaurant: id, success: { restaurant in
                    XCTAssert(restaurant.hours != nil)
                })
            }
        })
    }
    
    func testReviewAPI() {
        RARRestaurantAPI.shared.fetchRestauraunts(keyword: "Starbucks", latitude: 43.646210, longitude: -79.379539, offset: 0, limit: 10, success: { restaurants, _ in
            XCTAssert(restaurants.count > 0)
            if let restaurant = restaurants.first, let id = restaurant.id {
                RARRestaurantAPI.shared.fetchReviews(forRestaurant: id, success: { reviews in
                    //BEcause Yelp API doesn't return restaurant until there is at least one review, then those restaurants which have been returned in the first API call, should have at least one review
                    XCTAssert(reviews.count > 0)
                })
            }
        })
    }
    
}

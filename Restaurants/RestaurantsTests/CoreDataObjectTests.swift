//
//  CoreDataObjectTests.swift
//  RestaurantsTests
//
//  Created by Illya Bakurov on 10/2/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import XCTest
@testable import Restaurants
import CoreData

class CoreDataObjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRestaurantObject() {
        let jsonForRestaurant = ["id": "some_id",
                                 "name": "Title",
                                 "url": "https://yelp.com"]
        
        let restaurant = Restaurant(jsonForRestaurant)
        XCTAssert(restaurant.id != nil)
        
        let newRestaurant = Restaurant.copy(fromRestaurant: restaurant, insertIntoContext: nil)
        XCTAssert(restaurant.id == newRestaurant.id)
    }
    
    func testRestaurantLocationObject() {
        let jsonForRestaurantLocation = ["address1": "350 Queens Quay West",
                                         "city": "Toronto",
                                         "region": "ON",
                                         "country": "Canada",
                                         "zip_code": "M5V 3A7"]
        
        let restaurantLocation = RestaurantLocation(jsonForRestaurantLocation)
        XCTAssert(restaurantLocation.getAddress() != nil)
        
        let newRestaurantLocation = RestaurantLocation.copy(fromRestaurantLocation: restaurantLocation, insertIntoContext: nil)
        XCTAssert(restaurantLocation.getAddress() == newRestaurantLocation.getAddress())
    }
    
    func testPhotoObject() {        
        let photo = Photo(entity: NSEntityDescription.entity(forEntityName: "Photo", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        photo.url = "https://yelp.com"
        XCTAssert(photo.url != nil)
        
        let newPhoto = Photo.copy(fromPhoto: photo, insertIntoContext: nil)
        XCTAssert(photo.url == newPhoto.url)
    }
    
    func testHourObject() {
        let jsonForHour: [String: Any] = ["is_overnight": true,
                                          "end": "2100",
                                          "start": "1500",
                                          "day": 1]
        
        let hour = Hour(jsonForHour)
        XCTAssert(hour.start != nil && hour.end != nil)
        
        let newHour = Hour.copy(fromHour: hour, insertIntoContext: nil)
        XCTAssert(hour.start == newHour.start && hour.end == newHour.end)
    }
    
    func testRestaurantCategoryObject() {
        let category = RestaurantCategory("Title")
        XCTAssert(category.title != nil)
        
        let newCategory = RestaurantCategory.copy(fromCategory: category, insertIntoContext: nil)
        XCTAssert(category.title == newCategory.title)
    }
    
    func testReviewObject() {
        let jsonForReview: [String: Any] = ["text": "Review text",
                                            "url": "https://yelp.com",
                                            "time_created": "2017-10-01 13:00:00",
                                            "rating": 5,
                                            "user": [
                                                "name": "Name",
                                                "image_url": "https://yelp.com"
                                            ]]
        
        let review = Review(jsonForReview)
        XCTAssert(review.text != nil)
        
        let newReview = Review.copy(fromReview: review, insertIntoContext: nil)
        XCTAssert(review.text == newReview.text)
    }
}

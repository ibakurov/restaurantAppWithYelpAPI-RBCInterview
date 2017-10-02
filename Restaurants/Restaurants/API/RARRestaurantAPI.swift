//
//  RARRestaurantAPI.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class RARRestaurantAPI {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let keyToken = "token"
    }
    
    static let shared = RARRestaurantAPI()
    
    let manager: SessionManager = SessionManager()
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    func fetchRestauraunts(keyword: String, latitude: Double = 43.646210, longitude: Double = -79.379539, offset: Int, limit: Int, success: @escaping ([Restaurant], Int) -> (), failure: @escaping () -> () = {}) -> DataRequest? {
        //If we got token to make requests, we are good to fetch initial data, otherwise we should wait until token is fetched
        if let token = KeychainSwift.init().get(Constants.keyToken) {
            
            let headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            //Turning on spinning wheel on status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //Performing request to Yelp's API to obtain token.
            return manager.request("\(RARConstantsAPI.baseAPIURL)/v3/businesses/search?term=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&latitude=\(latitude)&longitude=\(longitude)&offset=\(offset)&limit=\(limit)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //Turning off spinning wheel on status bar
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //Unwrapping list of businesses from response
                if let result = response.result.value as? [String: Any], let total = result["total"] as? Int, let businesses = result["businesses"] as? [[String: Any]] {
                    var restaurants = [Restaurant]()
                    for business in businesses {
                        let restaurant = Restaurant(business)
                        restaurants.append(restaurant)
                    }
                    success(restaurants, total)
                    return
                }
                failure()
            }
        }
        return nil
    }
    
    func fetchDetails(forRestaurant restaurantId: String, success: @escaping (Restaurant) -> (), failure: @escaping () -> () = {}) -> DataRequest? {
        //If we got token to make requests, we are good to fetch initial data, otherwise we should wait until token is fetched
        if let token = KeychainSwift.init().get(Constants.keyToken) {
            
            let headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            //Turning on spinning wheel on status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //Performing request to Yelp's API to obtain token.
            return manager.request("\(RARConstantsAPI.baseAPIURL)/v3/businesses/\(restaurantId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //Turning off spinning wheel on status bar
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //Unwrapping the business data
                if let result = response.result.value as? [String: Any] {
                    success(Restaurant(result))
                    return
                }
                failure()
            }
        }
        return nil
    }
    
    func fetchReviews(forRestaurant restaurantId: String, success: @escaping ([Review]) -> (), failure: @escaping () -> () = {}) -> DataRequest? {
        //If we got token to make requests, we are good to fetch initial data, otherwise we should wait until token is fetched
        if let token = KeychainSwift.init().get(Constants.keyToken) {
            
            let headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            //Turning on spinning wheel on status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //Performing request to Yelp's API to obtain token.
            return manager.request("\(RARConstantsAPI.baseAPIURL)/v3/businesses/\(restaurantId)/reviews", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                //Turning off spinning wheel on status bar
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //Unwrapping all reviews
                if let result = response.result.value as? [String: Any], let _ = result["total"] as? Int, let reviewsData = result["reviews"] as? [[String: Any]] {
                    var reviews = [Review]()
                    for reviewData in reviewsData {
                        let review = Review(reviewData)
                        reviews.append(review)
                    }
                    success(reviews)
                    return
                }
                failure()
            }
        }
        return nil
    }
    
}

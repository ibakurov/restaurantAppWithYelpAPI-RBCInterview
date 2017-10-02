//
//  Review+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Review)
public class Review: NSManagedObject {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ json: [String: Any]) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Review", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        
        if let text = json["text"] as? String {
            self.text = text
        }
        if let url = json["url"] as? String {
            self.url = url
        }
        if let timeCreatedInString = json["time_created"] as? String, let timeCreated = Date.convertStringDateToDate(dateInString: timeCreatedInString, dateFormatInString: Constants.dateFormat) {
            self.timeCreated = NSDate(timeInterval: 0, since: timeCreated)
        }
        if let rating = json["rating"] as? Float {
            self.rating = rating
        }
        if let userDict = json["user"] as? [String: Any] {
            self.user = User(userDict)
        }
    }
    
    static func copy(fromReview review: Review, insertIntoContext context: NSManagedObjectContext?) -> Review {
        let newReview = Review(entity: NSEntityDescription.entity(forEntityName: "Review", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newReview.text = review.text
        newReview.url = review.url
        newReview.timeCreated = review.timeCreated
        newReview.rating = review.rating
        if let user = review.user {
            newReview.user = User.copy(fromUser: user, insertIntoContext: context)
        }
        
        return newReview
    }
    
}

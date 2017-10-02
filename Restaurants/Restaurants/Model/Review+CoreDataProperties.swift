//
//  Review+CoreDataProperties.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var text: String?
    @NSManaged public var timeCreated: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var rating: Float
    @NSManaged public var restaurant: Restaurant?
    @NSManaged public var user: User?

}

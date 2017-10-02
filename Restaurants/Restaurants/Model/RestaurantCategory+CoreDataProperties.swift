//
//  RestaurantCategory+CoreDataProperties.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData


extension RestaurantCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantCategory> {
        return NSFetchRequest<RestaurantCategory>(entityName: "RestaurantCategory")
    }

    @NSManaged public var title: String?
    @NSManaged public var restaurant: Restaurant?

}

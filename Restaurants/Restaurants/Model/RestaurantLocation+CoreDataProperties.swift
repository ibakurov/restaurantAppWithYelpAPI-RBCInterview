//
//  RestaurantLocation+CoreDataProperties.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData


extension RestaurantLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantLocation> {
        return NSFetchRequest<RestaurantLocation>(entityName: "RestaurantLocation")
    }

    @NSManaged public var address1: String?
    @NSManaged public var address2: String?
    @NSManaged public var address3: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var region: String?
    @NSManaged public var zip: String?
    @NSManaged public var restaurant: Restaurant?

}

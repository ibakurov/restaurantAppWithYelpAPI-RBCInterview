//
//  Hour+CoreDataProperties.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData


extension Hour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hour> {
        return NSFetchRequest<Hour>(entityName: "Hour")
    }

    @NSManaged public var end: String?
    @NSManaged public var isOvernight: Bool
    @NSManaged public var start: String?
    @NSManaged public var day: Int16
    @NSManaged public var restaurant: Restaurant?

}

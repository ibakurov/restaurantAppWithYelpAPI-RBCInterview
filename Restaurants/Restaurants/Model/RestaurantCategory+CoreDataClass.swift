//
//  RestaurantCategory+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RestaurantCategory)
public class RestaurantCategory: NSManagedObject {

    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ title: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "RestaurantCategory", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        
        self.title = title
    }
    
    static func copy(fromCategory category: RestaurantCategory, insertIntoContext context: NSManagedObjectContext?) -> RestaurantCategory {
        let newCategory = RestaurantCategory(entity: NSEntityDescription.entity(forEntityName: "RestaurantCategory", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newCategory.title = category.title
        
        return newCategory
    }
    
}

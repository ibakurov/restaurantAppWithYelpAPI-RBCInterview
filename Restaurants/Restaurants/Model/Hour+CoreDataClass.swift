//
//  Hour+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Hour)
public class Hour: NSManagedObject {
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ json: [String: Any]) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Hour", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        
        if let isOvernight = json["is_overnight"] as? Bool {
            self.isOvernight = isOvernight
        }
        if let end = json["end"] as? String {
            self.end = end
        }
        if let start = json["start"] as? String {
            self.start = start
        }
        if let day = json["day"] as? Int {
            self.day = Int16(day)
        }
    }
    
    static func copy(fromHour hour: Hour, insertIntoContext context: NSManagedObjectContext?) -> Hour {
        let newHour = Hour(entity: NSEntityDescription.entity(forEntityName: "Hour", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newHour.isOvernight = hour.isOvernight
        newHour.end = hour.end
        newHour.start = hour.start
        newHour.day = hour.day
        
        return newHour
    }
}

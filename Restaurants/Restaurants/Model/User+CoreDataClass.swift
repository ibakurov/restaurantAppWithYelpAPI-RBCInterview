//
//  User+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ json: [String: Any]) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "User", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        
        if let name = json["name"] as? String {
            self.name = name
        }
        if let imageURL = json["image_url"] as? String {
            self.imageURL = imageURL
        }
    }
    
    static func copy(fromUser user: User, insertIntoContext context: NSManagedObjectContext?) -> User {
        let newUser = User(entity: NSEntityDescription.entity(forEntityName: "User", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newUser.name = user.name
        newUser.imageURL = user.imageURL
        
        return newUser
    }
    
}

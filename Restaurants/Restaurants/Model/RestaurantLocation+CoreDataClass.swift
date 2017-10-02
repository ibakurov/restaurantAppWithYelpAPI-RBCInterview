//
//  RestaurantLocation+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RestaurantLocation)
public class RestaurantLocation: NSManagedObject {
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ json: [String: Any]) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "RestaurantLocation", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
       
        if let address1 = json["address1"] as? String, address1.characters.count > 0 {
            self.address1 = address1
        }
        if let address2 = json["address2"] as? String, address2.characters.count > 0 {
            self.address2 = address2
        }
        if let address3 = json["address3"] as? String, address3.characters.count > 0 {
            self.address3 = address3
        }
        if let city = json["city"] as? String, city.characters.count > 0 {
            self.city = city
        }
        if let region = json["region"] as? String, region.characters.count > 0 {
            self.region = region
        }
        if let country = json["country"] as? String, country.characters.count > 0 {
            self.country = country
        }
        if let zip = json["zip_code"] as? String, zip.characters.count > 0 {
            self.zip = zip
        }
    }
    
    static func copy(fromRestaurantLocation restaurantLocation: RestaurantLocation, insertIntoContext context: NSManagedObjectContext?) -> RestaurantLocation {
        let newRestaurantLocation = RestaurantLocation(entity: NSEntityDescription.entity(forEntityName: "RestaurantLocation", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newRestaurantLocation.address1 = restaurantLocation.address1
        newRestaurantLocation.address2 = restaurantLocation.address2
        newRestaurantLocation.address3 = restaurantLocation.address3
        newRestaurantLocation.city = restaurantLocation.city
        newRestaurantLocation.region = restaurantLocation.region
        newRestaurantLocation.country = restaurantLocation.country
        newRestaurantLocation.zip = restaurantLocation.zip
        
        return newRestaurantLocation
    }
    
    //-----------------
    // MARK: - Description
    //-----------------
    
    func getAddress() -> String? {
        var address = ""
        
        if let address1 = address1 {
            address += address1
        }
        if let address2 = address2 {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(address2)"
        }
        if let address3 = address3 {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil || address2 != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(address3)"
        }
        if let city = city {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil || address2 != nil || address3 != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(city)"
        }
        if let region = region {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil || address2 != nil || address3 != nil || city != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(region)"
        }
        if let country = country {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil || address2 != nil || address3 != nil || city != nil || region != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(country)"
        }
        if let zip = zip {
            let shouldAddCommaAndEmptySpaceBefore = address1 != nil || address2 != nil || address3 != nil || city != nil || region != nil || country != nil
            address += "\(shouldAddCommaAndEmptySpaceBefore ? ", " : "")\(zip)"
        }
        
        return address
    }
    
}

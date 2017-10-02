//
//  Favourites.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/30/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import Foundation
import CoreData

class Favourites {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    static let shared = Favourites()
    
    var restaurants = [Restaurant]()
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    init() {
        if let restaurants = fetchRestaurants() {
            for restaurant in restaurants {
                self.restaurants.append(Restaurant.copy(fromRestaurant: restaurant, insertIntoContext: nil))
            }
        }
    }
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    func fetchRestaurants() -> [Restaurant]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        do {
            if let favouritedRestaurants = try AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest) as? [Restaurant] {
                return favouritedRestaurants
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return nil
    }
    
    func addRestaurant(_ restaurant: Restaurant) {
        if let location = restaurant.location {
            AppDelegate.shared.persistentContainer.viewContext.insert(location)
        }
        if let photos = restaurant.photos {
            for photo in photos {
                if let entity = photo as? Photo {
                    AppDelegate.shared.persistentContainer.viewContext.insert(entity)
                }
            }
        }
        if let categories = restaurant.categories {
            for category in categories {
                if let entity = category as? RestaurantCategory {
                    AppDelegate.shared.persistentContainer.viewContext.insert(entity)
                }
            }
        }
        if let hours = restaurant.hours {
            for hour in hours {
                if let entity = hour as? Hour {
                    AppDelegate.shared.persistentContainer.viewContext.insert(entity)
                }
            }
        }
        if let reviews = restaurant.reviews {
            for review in reviews {
                if let entity = review as? Review {
                    if let user = entity.user {
                        AppDelegate.shared.persistentContainer.viewContext.insert(user)
                    }
                    AppDelegate.shared.persistentContainer.viewContext.insert(entity)
                }
            }
        }
        AppDelegate.shared.persistentContainer.viewContext.insert(restaurant)
        AppDelegate.shared.saveContext()
        restaurants.append(Restaurant.copy(fromRestaurant: restaurant, insertIntoContext: nil))
    }
    
    func removeRestaurant(_ restaurant: Restaurant) {
        if let fetchedRestaurants = fetchRestaurants() {
            for savedRestaurant in fetchedRestaurants {
                if savedRestaurant.id == restaurant.id {
                    AppDelegate.shared.persistentContainer.viewContext.delete(savedRestaurant)
                    AppDelegate.shared.saveContext()
                    break
                }
            }
        }
        for savedRestaurant in restaurants {
            if savedRestaurant.id == restaurant.id {
                restaurants.remove(savedRestaurant)
                break
            }
        }
    }
    
    func checkIfRestaurantIsInFavourites(_ id: String) -> Bool {
        for restaurant in restaurants {
            if restaurant.id == id {
                return restaurant.isFavourited
            }
        }
        return false
    }
}

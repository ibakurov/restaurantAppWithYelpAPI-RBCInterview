//
//  Restaurant+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData
import Alamofire
import AlamofireImage

@objc(Restaurant)
public class Restaurant: NSManagedObject {
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    convenience init(_ json: [String: Any]) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Restaurant", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
        
        if let id = json["id"] as? String {
            self.id = id
            self.isFavourited = Favourites.shared.checkIfRestaurantIsInFavourites(id)
        }
        if let title = json["name"] as? String {
            self.title = title
        }
        if let url = json["url"] as? String {
            self.url  = url
        }
        if let coordinates = json["coordinates"] as? [String: Any], let latitude = coordinates["latitude"] as? Double, let longitude = coordinates["longitude"] as? Double {
            self.latitude = latitude
            self.longitude = longitude
        }
        if let phone = json["phone"] as? String {
            self.phone = phone
        }
        if let rating = json["rating"] as? Float {
            self.rating = rating
        }
        if let price = json["price"] as? String {
            self.price = price
        }
        if let imageURL = json["image_url"] as? String {
            self.imageUrl = imageURL
        }
        if let location = json["location"] as? [String: Any] {
            self.location = RestaurantLocation(location)
        }
        if let photos = json["photos"] as? [String] {
            for photoURL in photos {
                let photo = Photo(entity: NSEntityDescription.entity(forEntityName: "Photo", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: nil)
                photo.url = photoURL
                self.addToPhotos(photo)
            }
        }
        if let multipleHours = json["hours"] as? [[String : Any]], let hours = multipleHours.first {
            let hour = Hour(hours)
            self.addToHours(hour)
        }
        if let categories = json["categories"] as? [[String: Any]] {
            for category in categories {
                if let title = category["title"] as? String {
                    self.addToCategories(RestaurantCategory(title))
                }
            }
        }
    }
    
    static func copy(fromRestaurant restaurant: Restaurant, insertIntoContext context: NSManagedObjectContext?) -> Restaurant {
        let newRestaurant = Restaurant(entity: NSEntityDescription.entity(forEntityName: "Restaurant", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newRestaurant.id = restaurant.id
        newRestaurant.title = restaurant.title
        newRestaurant.isFavourited = restaurant.isFavourited
        newRestaurant.url = restaurant.url
        newRestaurant.latitude = restaurant.latitude
        newRestaurant.longitude = restaurant.longitude
        newRestaurant.phone = restaurant.phone
        newRestaurant.rating = restaurant.rating
        newRestaurant.price = restaurant.price
        newRestaurant.imageUrl = restaurant.imageUrl
        if let location = restaurant.location {
            newRestaurant.location = RestaurantLocation.copy(fromRestaurantLocation: location, insertIntoContext: context)
        }
        if let photos = restaurant.photos?.allObjects as? [Photo] {
            var newPhotos = [Photo]()
            for photo in photos {
                newPhotos.append(Photo.copy(fromPhoto: photo, insertIntoContext: context))
            }
            newRestaurant.photos = NSSet(array: newPhotos)
        }
        if let categories = restaurant.categories?.allObjects as? [RestaurantCategory] {
            var newCategories = [RestaurantCategory]()
            for category in categories {
                newCategories.append(RestaurantCategory.copy(fromCategory: category, insertIntoContext: context))
            }
            newRestaurant.categories = NSSet(array: newCategories)
        }
        if let hours = restaurant.hours?.allObjects as? [Hour] {
            var newHours = [Hour]()
            for hour in hours {
                newHours.append(Hour.copy(fromHour: hour, insertIntoContext: context))
            }
            newRestaurant.hours = NSSet(array: newHours)
        }
        if let reviews = restaurant.photos?.allObjects as? [Review] {
            var newReviews = [Review]()
            for review in reviews {
                newReviews.append(Review.copy(fromReview: review, insertIntoContext: context))
            }
            newRestaurant.reviews = NSSet(array: newReviews)
        }
        
        return newRestaurant
    }
    
    //-----------------
    // MARK: - Image Downloading
    //-----------------
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 100 * 1024 * 1024
    )
    
    var request: Request?
    
    func getNetworkImage(_ urlString: String, completion: @escaping ((UIImage?, String?) -> ())) {
        request = Alamofire.request(urlString, method: .get).responseImage { [weak self] response in
            guard let image = response.result.value
                else {
                    completion(nil, self?.id)
                    return
            }
            completion(image, self?.id)
            self?.cacheImage(image, urlString: urlString)
            self?.cancelImageRequest()
        }
    }
    
    func cancelImageRequest() {
        let _ = request?.cancel()
        request = nil
    }
    
    //-----------------
    // MARK: - Image Caching
    //-----------------
    
    func cacheImage(_ image: Image, urlString: String) {
        imageCache.removeImage(withIdentifier: urlString)
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(_ urlString: String) -> UIImage? {
        return imageCache.image(withIdentifier: urlString)
    }
    
}

//
//  Restaurant+CoreDataProperties.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var phone: String?
    @NSManaged public var price: String?
    @NSManaged public var rating: Float
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var isFavourited: Bool
    @NSManaged public var categories: NSSet?
    @NSManaged public var hours: NSSet?
    @NSManaged public var location: RestaurantLocation?
    @NSManaged public var photos: NSSet?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for categories
extension Restaurant {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: RestaurantCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: RestaurantCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for hours
extension Restaurant {

    @objc(addHoursObject:)
    @NSManaged public func addToHours(_ value: Hour)

    @objc(removeHoursObject:)
    @NSManaged public func removeFromHours(_ value: Hour)

    @objc(addHours:)
    @NSManaged public func addToHours(_ values: NSSet)

    @objc(removeHours:)
    @NSManaged public func removeFromHours(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension Restaurant {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension Restaurant {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

//
//  Photo+CoreDataClass.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit
import AlamofireImage
import Alamofire

@objc(Photo)
public class Photo: NSManagedObject {

    //-----------------
    // MARK: - Initialization
    //-----------------
    
    static func copy(fromPhoto photo: Photo, insertIntoContext context: NSManagedObjectContext?) -> Photo {
        let newPhoto = Photo(entity: NSEntityDescription.entity(forEntityName: "Photo", in: AppDelegate.shared.persistentContainer.viewContext)!, insertInto: context)
        
        newPhoto.url = photo.url
        
        return newPhoto
    }
    
    //-----------------
    // MARK: - Image Downloading
    //-----------------
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 100 * 1024 * 1024
    )
    
    var request: Request?
    
    func getNetworkImage(_ urlString: String, completion: @escaping ((UIImage?) -> ())) {
        request = Alamofire.request(urlString, method: .get).responseImage { [weak self] response in
            guard let image = response.result.value
                else {
                    completion(nil)
                    return
            }
            completion(image)
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

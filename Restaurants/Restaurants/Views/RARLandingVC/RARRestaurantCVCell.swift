//
//  RARRestaurantCVCell.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit
import CoreData

protocol RARRestaurantCVCellDelegate: class {
    func restaurantFavouriteStatusChanged(_ restaurant: Restaurant)
}

class RARRestaurantCVCell: UICollectionViewCell {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    static let reuseIdentifier = "restaurantCell"
    
    weak var delegate: RARRestaurantCVCellDelegate?
    
    var currentRestaurant: Restaurant?

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantTitleLbl: UILabel!
    @IBOutlet weak var restaurantAddressLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPhotoAvailableLbl: UILabel!
    @IBOutlet weak var noPhotoAvailableImageView: UIImageView!
    
    @IBOutlet weak var addToFavouriteBtn: UIButton!
        
    //-----------------
    // MARK: - Setup UI
    //-----------------
    
    func setupUI(withRestaurant restaurant: Restaurant) {
        currentRestaurant = restaurant
        
        restaurantTitleLbl.text = restaurant.title
        restaurantAddressLbl.text = restaurant.location?.getAddress()
        
        resetImageView()
        setupImageView(withRestaurant: restaurant)
        
        setupFavouriteBtn(withRestaurant: restaurant)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.appNeutralGrey.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    func setupImageView(withRestaurant restaurant: Restaurant) {
        if let imageURL = restaurant.imageUrl, imageURL.characters.count > 0 {
            if let image = restaurant.cachedImage(imageURL) {
                restaurantImageView.image = image
            } else {
                resetImageView()
                loadingIndicator.startAnimating()
                restaurant.getNetworkImage(imageURL) { [weak self] image, restaurantId in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        if let image = image, self.currentRestaurant?.id == restaurantId {
                            self.restaurantImageView.image = image
                        } else if image == nil {
                            self.setImageViewToDefault()
                        }
                    }
                }
            }
        } else {
            setImageViewToDefault()
        }
    }
    
    func resetImageView() {
        restaurantImageView.image = nil
        restaurantImageView.isHidden = false
        noPhotoAvailableLbl.isHidden = true
        noPhotoAvailableImageView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func setImageViewToDefault() {
        restaurantImageView.isHidden = true
        noPhotoAvailableImageView.isHidden = false
        noPhotoAvailableLbl.isHidden = false
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        if let restaurant = currentRestaurant {
            if !restaurant.isFavourited {
                restaurant.isFavourited = true
                delegate?.restaurantFavouriteStatusChanged(restaurant)
            } else {
                restaurant.isFavourited = false
                delegate?.restaurantFavouriteStatusChanged(restaurant)
            }
            setupFavouriteBtn(withRestaurant: restaurant)
        }
    }
    
    func setupFavouriteBtn(withRestaurant restaurant: Restaurant) {
        if restaurant.isFavourited {
            addToFavouriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            addToFavouriteBtn.setImage(UIImage(named: "heartOutline"), for: .normal)
        }
    }
    
}

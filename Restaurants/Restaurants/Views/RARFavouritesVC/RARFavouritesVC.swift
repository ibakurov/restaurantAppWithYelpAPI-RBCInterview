//
//  RARFavouritesVC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit
import CoreData

class RARFavouritesVC: UIViewController {
    
    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let numberOfItemsInRow = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 2
        static let edgeInsetsForSection = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        static let minimumLineSpacingForSection: CGFloat = 10.0
        static let minimumInteritemSpacingForSection: CGFloat = 10.0
        static let idealWidthForItem: CGFloat = 160.0
        static let idealHeightForItem: CGFloat = 250.0
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UINib(nibName: "RARRestaurantCVCell", bundle: nil), forCellWithReuseIdentifier: RARRestaurantCVCell.reuseIdentifier)
        }
    }
    
    //We use restaurant ids' to track which restaurants have been unfavourited.
    var unfavouritedRestaurantIds = [String]()
    
    //This variable tracks if we are leaving VC to go to details VC. IF so, we won't clean up unfavourited restaurants.
    var goingIntoDetailsVC = false
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favourites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        goingIntoDetailsVC = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !goingIntoDetailsVC {
            checkOnUnfavouritedRestaurantsAndCleanUp()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    func checkOnUnfavouritedRestaurantsAndCleanUp() {
        for id in unfavouritedRestaurantIds {
            for restaurant in Favourites.shared.restaurants {
                if id == restaurant.id {
                    Favourites.shared.removeRestaurant(restaurant)
                }
            }
        }
        unfavouritedRestaurantIds.removeAll()
    }
    
}

extension RARFavouritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Favourites.shared.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARRestaurantCVCell.reuseIdentifier, for: indexPath) as! RARRestaurantCVCell
        cell.setupUI(withRestaurant: Favourites.shared.restaurants[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = Favourites.shared.restaurants[indexPath.row]
        if restaurant.id != nil {
            let restaurantDetailsVC = RARRestaurantDetailsVC(nibName: "RARRestaurantDetailsVC", bundle: nil)
            restaurantDetailsVC.restaurant = restaurant
            restaurantDetailsVC.hidesBottomBarWhenPushed = true
            goingIntoDetailsVC = true
            navigationController?.pushViewController(restaurantDetailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Calculating width of an item based on edge insets, interitem spacing and number of items per row.
        let widthOfEdges = Constants.edgeInsetsForSection.left + Constants.edgeInsetsForSection.right
        let widthOfInteritemSpace = Constants.minimumInteritemSpacingForSection * CGFloat(Constants.numberOfItemsInRow - 1)
        let widthOfSpaceToPlaceItems = collectionView.frame.width - widthOfEdges - widthOfInteritemSpace
        let widthOfItem = widthOfSpaceToPlaceItems / CGFloat(Constants.numberOfItemsInRow)
        
        //Calculating height of an item based on aspect scale to width
        let heightOfItem = Constants.idealHeightForItem * (widthOfItem / Constants.idealWidthForItem)
        
        return CGSize(width: widthOfItem, height: heightOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.edgeInsetsForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacingForSection
    }
    
}

extension RARFavouritesVC: RARRestaurantCVCellDelegate {
    
    //-----------------
    // MARK: - RARRestaurantCVCellDelegate
    //-----------------
    
    func restaurantFavouriteStatusChanged(_ restaurant: Restaurant) {
        NotificationCenter.default.post(name: NSNotification.Name("FavouriteStatusChanged"), object: nil, userInfo: ["restaurant": restaurant])
        if let id = restaurant.id {
            if restaurant.isFavourited {
                unfavouritedRestaurantIds.remove(id)
            } else {
                unfavouritedRestaurantIds.append(id)
            }
        }
    }
    
}

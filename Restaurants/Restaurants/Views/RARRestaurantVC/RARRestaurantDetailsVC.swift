//
//  RARRestaurantDetailsVC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit
import Alamofire

class RARRestaurantDetailsVC: UIViewController {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let edgeInsetsForSection = UIEdgeInsets.zero
        static let minimumLineSpacingForSection: CGFloat = 10.0
        static let minimumInteritemSpacingForSection: CGFloat = 10.0
        static let heightForReviewItem: CGFloat = 150.0
    }
    
    enum Components: Int {
        case photos = 0, title = 1, address = 2, reviews = 3
        
        func heightForItem() -> CGFloat {
            switch self {
            case .photos:
                return 250.0
            case .title:
                return 44.0
            case .address:
                return 44.0
            case .reviews:
                return 44.0
            }
        }
        
        static func numberOfComponents() -> Int {
            return 4
        }
    }

    var restaurant: Restaurant!
    var loadingPhotos = false
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UINib(nibName: "RARRestaurantDetailsPhotosCVCell", bundle: nil), forCellWithReuseIdentifier: RARRestaurantDetailsPhotosCVCell.reuseIdentifier)
            collectionView.register(UINib(nibName: "RARTextCVCell", bundle: nil), forCellWithReuseIdentifier: RARTextCVCell.reuseIdentifier)
            collectionView.register(UINib(nibName: "RARReviewCVCell", bundle: nil), forCellWithReuseIdentifier: RARReviewCVCell.reuseIdentifier)
        }
    }
    
    var currentRequestForReviews: DataRequest?
    var currentRequestForData: DataRequest?
    
    var favouriteBtn: UIBarButtonItem!
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingPhotos = true
        fetchDetailsAboutRestaurant()
        fetchReviews()

        addFavouriteBtn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentRequestForData?.cancel()
        currentRequestForReviews?.cancel()
        
        AppDelegate.shared.saveContext()
    }
    
    func addFavouriteBtn() {
        favouriteBtn = UIBarButtonItem(image: UIImage(named: (restaurant.isFavourited ? "heart" : "heartOutline")), style: .plain, target: self, action: #selector(favouriteRestaurant))
        favouriteBtn.tintColor = restaurant.isFavourited ? UIColor.appPrimary : UIColor.appNeutralGrey
        favouriteBtn.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = favouriteBtn
    }
    
    //-----------------
    // MARK: - Methods
    //-----------------
    
    @objc func favouriteRestaurant() {
        restaurant.isFavourited = !restaurant.isFavourited
        NotificationCenter.default.post(name: NSNotification.Name("FavouriteStatusChanged"), object: nil, userInfo: ["restaurant": restaurant])
        if restaurant.isFavourited {
            let newRestaurant = Restaurant.copy(fromRestaurant: restaurant, insertIntoContext: AppDelegate.shared.persistentContainer.viewContext)
            Favourites.shared.addRestaurant(newRestaurant)
        } else {
            Favourites.shared.removeRestaurant(restaurant)
        }
        favouriteBtn.image = UIImage(named: (restaurant.isFavourited ? "heart" : "heartOutline"))
        favouriteBtn.tintColor = restaurant.isFavourited ? UIColor.appPrimary : UIColor.appNeutralGrey
    }
    
}

extension RARRestaurantDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let reviews = restaurant.reviews, reviews.allObjects.count > 0 {
             return Components.numberOfComponents() + reviews.allObjects.count
        }
        return Components.numberOfComponents() - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if Components.photos.rawValue == indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARRestaurantDetailsPhotosCVCell.reuseIdentifier, for: indexPath) as! RARRestaurantDetailsPhotosCVCell
            cell.setup(withPhotos: restaurant.photos?.allObjects as! [Photo], loadPhotos: loadingPhotos)
            return cell
        } else if Components.title.rawValue == indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARTextCVCell.reuseIdentifier, for: indexPath) as! RARTextCVCell
            cell.setup(withText: restaurant.title)
            cell.textLbl.font = UIFont.preferredFont(forTextStyle: .title2)
            return cell
        } else if Components.address.rawValue == indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARTextCVCell.reuseIdentifier, for: indexPath) as! RARTextCVCell
            cell.setup(withText: restaurant.location?.getAddress())
            cell.textLbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
            return cell
        } else if Components.reviews.rawValue == indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARTextCVCell.reuseIdentifier, for: indexPath) as! RARTextCVCell
            cell.setup(withText: "Reviews")
            cell.textLbl.font = UIFont.preferredFont(forTextStyle: .body)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARReviewCVCell.reuseIdentifier, for: indexPath) as! RARReviewCVCell
            cell.setup(withReview: (restaurant.reviews?.allObjects as! [Review])[indexPath.item - Components.numberOfComponents()])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Components.photos.rawValue == indexPath.item {
            return CGSize(width: collectionView.frame.width, height: Components.photos.heightForItem())
        } else if Components.title.rawValue == indexPath.item {
            return CGSize(width: collectionView.frame.width, height: Components.title.heightForItem())
        } else if Components.address.rawValue == indexPath.item {
            return CGSize(width: collectionView.frame.width, height: Components.address.heightForItem())
        } else if Components.reviews.rawValue == indexPath.item {
            return CGSize(width: collectionView.frame.width, height: Components.reviews.heightForItem())
        } else {
            return CGSize(width: collectionView.frame.width, height: Constants.heightForReviewItem)
        }
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

extension RARRestaurantDetailsVC {
    
    func fetchDetailsAboutRestaurant() {
        if let restaurantId = restaurant.id {
            if let currentRequestForData = RARRestaurantAPI.shared.fetchDetails(forRestaurant: restaurantId, success: { [weak self] restaurant in
                guard let `self` = self else { return }
                self.restaurant.photos = restaurant.photos
                DispatchQueue.main.async {
                    self.loadingPhotos = false
                    self.collectionView.reloadData()
                }
            }) {
                self.currentRequestForData = currentRequestForData
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.fetchDetailsAboutRestaurant()
                })
            }
        }
    }
    
    func fetchReviews() {
        if let restaurantId = restaurant.id {
            if let currentRequestForReviews = RARRestaurantAPI.shared.fetchReviews(forRestaurant: restaurantId, success: { [weak self] reviews in
                guard let `self` = self else { return }
                self.restaurant.reviews = NSSet(array: reviews)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }) {
                self.currentRequestForReviews = currentRequestForReviews
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.fetchReviews()
                })
            }
        }
    }
}

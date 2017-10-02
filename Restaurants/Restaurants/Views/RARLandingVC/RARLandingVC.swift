//
//  RARLandingVC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class RARLandingVC: UIViewController {
    
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
        static let percentageOfItemsWhichShouldBeScrolledBeforeLoadingNextBatch: Double = 50 / 100
        static let heightOfFooter: CGFloat = 125.0
        static let initialKeywordToSearch = "Starbucks"
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UINib(nibName: "RARRestaurantCVCell", bundle: nil), forCellWithReuseIdentifier: RARRestaurantCVCell.reuseIdentifier)
            collectionView.register(UINib(nibName: "RARLoadingView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: RARLoadingView.reuseIdentifier)
        }
    }
    
    var arrayWithRestaurants = [Restaurant]()
    
    var searchBar: UISearchBar!
    var sortBtn: UIBarButtonItem!

    //These are variables to manage paging for API requests
    var offset = 0
    var limit = 10
    var total: Int?
    var isAPICallActive = false
    
    //We store current data request to cancel it if needed
    var currentRequest: DataRequest?
    
    //Location manager to follow the users location
    let locationManager = CLLocationManager()
    var isLocationAllowed = false
    var alertToAskToAllowAccess: UIAlertController?
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        addSearchBar()
        addSortBtn()
        fetchRequestData()
        
        
        //Observe when app returned to active state after switching to settings
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(favouriteStatusChanged(_:)), name: NSNotification.Name("FavouriteStatusChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavouriteStatusChanged"), object: nil)
    }
    
    func addSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        searchBar.placeholder = "Search for restaurants"
        searchBar.autocapitalizationType = .words
        searchBar.text = Constants.initialKeywordToSearch
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func addSortBtn() {
        sortBtn = UIBarButtonItem(image: UIImage(named: "sortedAsc"), style: .plain, target: self, action: #selector(sort(_:)))
        sortBtn.tintColor = UIColor.appNeutralGrey
        sortBtn.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = sortBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func appBecameActive() {
        determineLocationServiceAccess()
    }
}

extension RARLandingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //-----------------
    // MARK: - UICollectionView Delegate & DataSource
    //-----------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayWithRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RARRestaurantCVCell.reuseIdentifier, for: indexPath) as! RARRestaurantCVCell
        cell.setupUI(withRestaurant: arrayWithRestaurants[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item >= Int(Double(arrayWithRestaurants.count) * Constants.percentageOfItemsWhichShouldBeScrolledBeforeLoadingNextBatch) && offset <= (total ?? 0) && !isAPICallActive {
            fetchRequestData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isAPICallActive {
            return CGSize(width: collectionView.frame.size.width, height: Constants.heightOfFooter)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: RARLoadingView.reuseIdentifier, for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = arrayWithRestaurants[indexPath.row]
        if restaurant.id != nil {
            let restaurantDetailsVC = RARRestaurantDetailsVC(nibName: "RARRestaurantDetailsVC", bundle: nil)
            restaurantDetailsVC.restaurant = restaurant
            restaurantDetailsVC.hidesBottomBarWhenPushed = true
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

extension RARLandingVC: RARRestaurantCVCellDelegate {
   
    //-----------------
    // MARK: - RARRestaurantCVCellDelegate
    //-----------------
    
    func restaurantFavouriteStatusChanged(_ restaurant: Restaurant) {
        if restaurant.isFavourited {
            let newRestaurant = Restaurant.copy(fromRestaurant: restaurant, insertIntoContext: AppDelegate.shared.persistentContainer.viewContext)
            Favourites.shared.addRestaurant(newRestaurant)
        } else {
            Favourites.shared.removeRestaurant(restaurant)
        }
    }
    
    @objc func favouriteStatusChanged(_ notification: NSNotification) {
        if let userInfo = notification.userInfo, let restaurantFavourited = userInfo["restaurant"] as? Restaurant {
            for restaurant in arrayWithRestaurants {
                if restaurant.id == restaurantFavourited.id {
                    restaurant.isFavourited = restaurantFavourited.isFavourited
                    break
                }
            }
            collectionView.reloadData()
        }
    }
    
}

extension RARLandingVC {
    
    //-----------------
    // MARK: - API Fetching
    //-----------------
    
    func fetchRequestData() {
        if let keyword = searchBar.text, keyword.characters.count > 0, !isAPICallActive, isLocationAllowed {
            if let location = locationManager.location {
                isAPICallActive = true
                if let currentRequest = RARRestaurantAPI.shared.fetchRestauraunts(keyword: keyword, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, offset: offset, limit: limit, success: { [weak self] restaurants, total in
                    guard let `self` = self else { return }
                    self.arrayWithRestaurants.append(contentsOf: restaurants)
                    self.total = total
                    self.offset += self.limit
                    self.isAPICallActive = false
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }) {
                    self.currentRequest = currentRequest
                } else {
                    isAPICallActive = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.fetchRequestData()
                    })
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.fetchRequestData()
                })
            }
        }
    }
}

extension RARLandingVC: UISearchBarDelegate {
    
    //-----------------
    // MARK: - UISearchBarDelegate
    //-----------------
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Reset API variables
        total = 0
        offset = 0
        //Cancel current request
        currentRequest?.cancel()
        isAPICallActive = false
        //Clean data from previous request
        arrayWithRestaurants.removeAll()
        //Reset sorting btn
        sortBtn.tintColor = UIColor.appNeutralGrey
        sortBtn.tag = 0
        sortBtn.image = UIImage(named: "sortedAsc")
        //Resign keyboard
        searchBar.resignFirstResponder()
        //Make API request
        fetchRequestData()
    }
    
}

extension RARLandingVC {
    
    //-----------------
    // MARK: - Sorting
    //-----------------
    
    @objc func sort(_ sender: UIBarButtonItem) {
        sortBtn.tintColor = UIColor.appPrimary
        if sender.tag == 0 {
            sender.image = UIImage(named: "sortedAsc")
            sender.tag = 1
            arrayWithRestaurants = quicksort(arrayWithRestaurants, ascending: true)
        } else if sender.tag == 1 {
            sender.image = UIImage(named: "sortedDesc")
            sender.tag = 0
            arrayWithRestaurants = quicksort(arrayWithRestaurants, ascending: false)
        }
        collectionView.reloadData()
    }
    
    func quicksort(_ a: [Restaurant], ascending: Bool) -> [Restaurant] {
        guard a.count > 1 else { return a }
        
        let pivot = a[a.count/2]
        let less = a.filter { (ascending ? ($0.title ?? "" < pivot.title ?? "") : ($0.title ?? "" > pivot.title ?? "")) }
        let equal = a.filter { $0.title == pivot.title }
        let greater = a.filter { (ascending ? ($0.title ?? "" > pivot.title ?? "") : ($0.title ?? "" < pivot.title ?? "")) }
        
        return quicksort(less, ascending: ascending) + equal + quicksort(greater, ascending: ascending)
    }
    
}

extension RARLandingVC: CLLocationManagerDelegate {
    
    //-----------------
    // MARK: - Location Manager
    //-----------------
    
    ///Allow location service
    func determineLocationServiceAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //We need user's location only when the app is in use.
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLocationAllowed = true
            alertToAskToAllowAccess?.dismiss(animated: true, completion: nil)
        case .restricted, .denied:
            isLocationAllowed = false
            showThatThisAppNeedToHaveAccessToLocation()
        }
    }
    
    //Delegate method of CLLocationManager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //This method fires on initial assign of delegate to locationManager

        //If we have authorization we can start tracking users location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            isLocationAllowed = true
            locationManager.startUpdatingLocation()
            //If we don't yet have any data fetched, let's do it now
            if arrayWithRestaurants.count == 0 {
                fetchRequestData()
            }
        } else {
            isLocationAllowed = false
            //If not, we should stop doing that
            locationManager.stopUpdatingLocation()
            showThatThisAppNeedToHaveAccessToLocation()
        }
        //IF status is notDetermined we should ask user for location access
        if status == .notDetermined {
            determineLocationServiceAccess()
        }
    }
    
    func showThatThisAppNeedToHaveAccessToLocation() {
        alertToAskToAllowAccess = UIAlertController(title: "Location access", message: "This app requires access to your location", preferredStyle: .alert)
        alertToAskToAllowAccess!.addAction(UIAlertAction(title: "To Settings", style: .default, handler: { _ in
            self.openSettings()
        }))
        present(alertToAskToAllowAccess!, animated: true, completion: nil)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

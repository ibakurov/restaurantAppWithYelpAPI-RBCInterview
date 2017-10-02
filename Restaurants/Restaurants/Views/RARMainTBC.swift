//
//  RARMainTBC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/28/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARMainTBC: UITabBarController {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    var wasUISetup = false
    
    //The type of buttons on the tab bar
    enum TabBarItems : Int {
        case explore = 0, favourites = 1
    }
    
    let arrayWithUnselectedImages: [String] = [
        "unselectedRestaurantsIcon", "unselectedFavourites"
    ]
    
    let arrayWithSelectedImages: [String] = [
        "selectedRestaurantsIcon", "selectedFavourites"
    ]
    
    // Array of titles
    let arrayOfTitles: [String] = [/*"Restaurants", "Favourites"*/]
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add appropriate view controllers to tab bar controller
        self.viewControllers = [RARLandingNC(), RARFavouritesNC()]
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if !wasUISetup {
            //Setting the height of tab bar to heightOfTabBar value
            let heightOfTabBar : CGFloat = 45
            var tabFrame = tabBar.frame
            tabFrame.size.height = heightOfTabBar
            //We also should adjust its origin point
            tabFrame.origin.y = view.frame.size.height - heightOfTabBar
            tabBar.frame = tabFrame
            
            //Making tab bar look white
            tabBar.backgroundColor = UIColor.white
            tabBar.backgroundImage = UIImage()
            
            //Ading the grey border to the tab bar, so it is differentiated from the content of the view controller
            tabBar.layer.shadowColor = UIColor(red: 40/255.0, green: 64/255.0, blue: 84/255.0, alpha: 0.3).cgColor
            tabBar.layer.shadowRadius = -2.0
            tabBar.layer.shadowOpacity = 0.25
            tabBar.layer.shadowOffset = CGSize(width: 0.0, height: tabBar.layer.shadowRadius)
            
            //Customizing tab bar buttons
            customizeUIOfTabBarButtons()
            
            wasUISetup = true
        }
    }
    
    //-----------------
    // MARK: - Setup UI
    //-----------------
    
    func customizeUIOfTabBarButtons() {
        // Customize tabs - iterate through tabs and change images/selected images (and render mode)
        for i in 0..<arrayWithUnselectedImages.count {
            //Unwrapping array with all buttons of tab bar
            if let items = tabBar.items {
                //Taking proper item from items
                let item = items[i] as UITabBarItem
                //Get name of image for not selected style
                let nameOfImage = arrayWithUnselectedImages[i]
                //Trying to init the image with the name
                if var itemImage = UIImage(named: nameOfImage) {
                    //Setting proper render mode
                    itemImage = itemImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                    //Assigning the image
                    item.image = itemImage
                    //If we do have a title for this tab we should move image higher
                    if arrayOfTitles.count > i {
                        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 3, right: 0)
                    } else {
                        //Else position image in the center of th etab
                        item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                    }
                }
                //Unwrapping name of image for selected style, which corresponds to current tab bar style
                let nameOfSelectedImage = arrayWithSelectedImages[i]
                //Trying to init the image with the name
                if var itemImageSelected = UIImage(named: nameOfSelectedImage) {
                    //Setting proper render mode
                    itemImageSelected = itemImageSelected.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                    //Assigning the image
                    item.selectedImage = itemImageSelected
                }
            }
        }
        //Customize titles of tab bar
        for j in 0..<arrayOfTitles.count {
            if let tabItems = tabBar.items {
                let item = tabItems[j] as UITabBarItem
                item.title = arrayOfTitles[j]
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)

                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.appNeutralGrey], for:.normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.appPrimary], for:.selected)
            }
        }
    }

}

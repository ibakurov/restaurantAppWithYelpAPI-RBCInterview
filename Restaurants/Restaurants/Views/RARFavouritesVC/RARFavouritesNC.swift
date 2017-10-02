//
//  RARFavouritesNC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARFavouritesNC: UINavigationController {

    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.appPrimary

        pushViewController(RARFavouritesVC(nibName: "RARFavouritesVC", bundle: nil), animated: false)
    }

}

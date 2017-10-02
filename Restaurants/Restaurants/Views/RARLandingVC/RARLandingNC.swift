//
//  RARLandingNC.swift
//  Restaurants
//
//  Created by Illya Bakurov on 9/29/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARLandingNC: UINavigationController {

    //-----------------
    // MARK: - Initialization
    //-----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.appPrimary
        
        pushViewController(RARLandingVC(nibName: "RARLandingVC", bundle: nil), animated: false)
    }

}

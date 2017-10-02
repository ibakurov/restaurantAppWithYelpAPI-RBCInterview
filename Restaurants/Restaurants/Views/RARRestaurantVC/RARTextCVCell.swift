//
//  RARTitleCVCell.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARTextCVCell: UICollectionViewCell {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    static var reuseIdentifier = "textCell"
    
    @IBOutlet weak var textLbl: UILabel!
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    func setup(withText text: String?) {
        textLbl.text = text
    }
}

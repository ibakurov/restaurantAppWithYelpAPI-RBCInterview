//
//  RARReviewCVCell.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARReviewCVCell: UICollectionViewCell {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    static var reuseIdentifier = "reviewCell"
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var reviewTextLbl: UILabel!
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    func setup(withReview review: Review) {
        userNameLbl.text = review.user?.name
        reviewTextLbl.text = review.text
    }

}

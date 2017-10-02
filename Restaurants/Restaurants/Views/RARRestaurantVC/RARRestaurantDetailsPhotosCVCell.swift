//
//  RARRestaurantDetailsPhotosCVCell.swift
//  Restaurants
//
//  Created by Illya Bakurov on 10/1/17.
//  Copyright © 2017 ibakurov. All rights reserved.
//

import UIKit

class RARRestaurantDetailsPhotosCVCell: UICollectionViewCell, UIScrollViewDelegate {

    //-----------------
    // MARK: - Variables
    //-----------------
    
    struct Constants {
        static let howManyPhotosToShow = 10
    }
    
    static let reuseIdentifier = "photosCell"
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var pageControler: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noPhotoImageView: UIImageView!
    @IBOutlet weak var noPhotoLbl: UILabel!
    
    var photos: [Photo]!
    
    //-----------------
    // MARK: - Initialization
    //-----------------
    
    func setup(withPhotos photos: [Photo], loadPhotos: Bool) {
        self.photos = photos
        if loadPhotos {
            setupLoadingPhotosUI()
        } else {
            if photos.count == 0 {
                setupNoPhotosAvailableUI()
            } else {
                pageControler.numberOfPages = min(Constants.howManyPhotosToShow, photos.count)
                pageControler.isHidden = false
                scrollView.isHidden = false
                noPhotoImageView.isHidden = true
                noPhotoLbl.isHidden = true
                activityIndicator.stopAnimating()
                layoutSubviews()
            }
        }
    }
    
    func setupNoPhotosAvailableUI() {
        pageControler.isHidden = true
        scrollView.isHidden = true
        noPhotoImageView.isHidden = false
        noPhotoLbl.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func setupLoadingPhotosUI() {
        pageControler.isHidden = true
        scrollView.isHidden = true
        noPhotoImageView.isHidden = true
        noPhotoLbl.isHidden = true
        activityIndicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addImageViewsToScrollView(withPhotos: photos)
    }
    
    //-----------------
    // MARK: - Setup UI
    //-----------------
    
    func addImageViewsToScrollView(withPhotos photos: [Photo]) {
        for i in 0..<min(Constants.howManyPhotosToShow, photos.count) {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: CGFloat(i) * scrollView.frame.width, y: 0), size: scrollView.frame.size))
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            setupImageView(withPhoto: photos[i], andImageView: imageView)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize.width = max(scrollView.frame.width, scrollView.frame.width * CGFloat(min(Constants.howManyPhotosToShow, photos.count)))
    }
    
    func setupImageView(withPhoto photo: Photo, andImageView imageView: UIImageView) {
        if let imageURL = photo.url, imageURL.characters.count > 0 {
            if let image = photo.cachedImage(imageURL) {
                imageView.image = image
            } else {
                activityIndicator.startAnimating()
                photo.getNetworkImage(imageURL) { [weak self, imageView] image in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        if let image = image {
                            imageView.image = image
                        } else if image == nil {
                            imageView.image = nil
                            imageView.backgroundColor = UIColor.appNeutralGrey
                        }
                    }
                }
            }
        }
    }
    
    //-----------------
    // MARK: - ScrollView Delegate
    //-----------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Calculating current page index
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControler.currentPage = fractionalPage
    }

}

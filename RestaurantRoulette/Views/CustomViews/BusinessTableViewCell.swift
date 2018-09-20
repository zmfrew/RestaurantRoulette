//
//  BusinessTableViewCell.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class BusinessTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var businessCellView: UIView!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noRatingAvailableLabel: UILabel!
    @IBOutlet weak var ratingStarOne: UIImageView!
    @IBOutlet weak var ratingStarTwo: UIImageView!
    @IBOutlet weak var ratingStarThree: UIImageView!
    @IBOutlet weak var ratingStarFour: UIImageView!
    @IBOutlet weak var ratingStarFive: UIImageView!
    @IBOutlet weak var favoriteStarButton: UIButton!
    
    // MARK: - Properties
    var restaurant: Restaurant?
    var business: CDYelpBusiness? {
        didSet {
            DispatchQueue.main.async {
                self.updateCell()
                self.updateImage()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let business = business else { return }
        
        if RestaurantController.shared.isBusinessAFavorite(business: business) {
            guard let restaurant = restaurant else { return }
            RestaurantController.shared.delete(restaurant)
            setFavoriteButtonBackground()
        } else {
            self.restaurant = RestaurantController.shared.addRestaurantFrom(business: business)
            setFavoriteButtonBackground()
        }
    }
    
    // MARK: - Methods
    private func updateCell() {
        businessCellView.layer.cornerRadius = 16
        businessImageView.layer.cornerRadius = businessImageView.layer.frame.height / 2
        
        guard let business = business else { return }
        
        // FIXME: - Insert a new default image with the App Icon
        businessImageView.image = UIImage(named: "mockShannons")
        nameLabel.text = business.name
        hideStarsIfNecessary(Int(business.rating ?? 0))
        setFavoriteButtonBackground()
    }
    
    private func updateImage() {
        guard let business = business,
            let imageURL = business.imageUrl,
            let imageData = try? Data(contentsOf: imageURL)
            else { return }
        
        businessImageView.image = UIImage(data: imageData) ?? UIImage(named: "mockShannons")
    }
    
    private func hideStarsIfNecessary(_ rating: Int) {
        switch rating {
        case 0:
            ratingStarOne.isHidden = true
            ratingStarTwo.isHidden = true
            ratingStarThree.isHidden = true
            ratingStarFour.isHidden = true
            ratingStarFive.isHidden = true
        case 1:
            ratingStarTwo.isHidden = true
            ratingStarThree.isHidden = true
            ratingStarFour.isHidden = true
            ratingStarFive.isHidden = true
        case 2:
            ratingStarThree.isHidden = true
            ratingStarFour.isHidden = true
            ratingStarFive.isHidden = true
        case 3:
            ratingStarFour.isHidden = true
            ratingStarFive.isHidden = true
        case 4:
            ratingStarFive.isHidden = true
        case 5:
            break
        default:
            ratingStarOne.isHidden = true
            ratingStarTwo.isHidden = true
            ratingStarThree.isHidden = true
            ratingStarFour.isHidden = true
            ratingStarFive.isHidden = true
            noRatingAvailableLabel.isHidden = false
            noRatingAvailableLabel.text = "No rating available."
        }
    }
    
    func setFavoriteButtonBackground() {
        let imageName = RestaurantController.shared.isBusinessAFavorite(business: business) ? "starBlue" : "starGray"
        let image = UIImage(named: imageName)
        favoriteStarButton.setBackgroundImage(image, for: UIControlState())
    }
    
}


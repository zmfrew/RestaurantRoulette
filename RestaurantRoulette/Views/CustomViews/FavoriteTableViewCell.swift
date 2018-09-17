//
//  FavoriteTableViewCell.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var favoriteCellView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noRatingAvailableLabel: UILabel!
    @IBOutlet weak var ratingStarOne: UIImageView!
    @IBOutlet weak var ratingStarTwo: UIImageView!
    @IBOutlet weak var ratingStarThree: UIImageView!
    @IBOutlet weak var ratingStarFour: UIImageView!
    @IBOutlet weak var ratingStarFive: UIImageView!
    
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            DispatchQueue.main.async {
                self.updateCell()
            }
        }
    }
    
    // MARK: - Methods
    private func updateCell() {
        favoriteCellView.layer.cornerRadius = 16
        restaurantImageView.layer.cornerRadius = restaurantImageView.layer.frame.height / 2
    
        guard let restaurant = restaurant else { return }
        nameLabel.text = restaurant.name
        restaurantImageView.image = restaurant.image
        hideStarsIfNecessary(restaurant.rating)
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
    
}

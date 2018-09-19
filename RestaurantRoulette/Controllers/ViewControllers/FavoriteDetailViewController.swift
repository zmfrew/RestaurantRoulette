//
//  FavoriteDetailViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class FavoriteDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var noRatingAvailableLabel: UILabel!
    @IBOutlet weak var ratingStarOne: UIImageView!
    @IBOutlet weak var ratingStarTwo: UIImageView!
    @IBOutlet weak var ratingStarThree: UIImageView!
    @IBOutlet weak var ratingStarFour: UIImageView!
    @IBOutlet weak var ratingStarFive: UIImageView!
    @IBOutlet weak var noCaterogiesAvailableLabel: UILabel!
    @IBOutlet weak var categoryOneLabel: UILabel!
    @IBOutlet weak var categoryTwoLabel: UILabel!
    @IBOutlet weak var categoryThreeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: - Save to CloudKit and use CKShare
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    private func updateViews() {
        guard let restaurant = restaurant else { return }
        
        restaurantImageView.image = restaurant.image
        restaurantImageView.layer.cornerRadius = restaurantImageView.layer.frame.height / 2
        hideStarsIfNecessary(restaurant.rating)
        updateCategoryLabels(restaurant.categories)
        phoneNumberLabel.text = PhoneNumberFormatter.formatPhoneNumber(restaurant.phoneNumber)
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
    
    private func updateCategoryLabels(_ categories: [String]) {
        let count = categories.count
        switch count {
        case 1:
            categoryOneLabel.text = categories[0]
            categoryTwoLabel.isHidden = true
            categoryThreeLabel.isHidden = true
        case 2:
            categoryOneLabel.text = categories[0]
            categoryTwoLabel.text = categories[1]
            categoryThreeLabel.isHidden = true
        case 3:
            categoryOneLabel.text = categories[0]
            categoryTwoLabel.text = categories[1]
            categoryThreeLabel.text = categories[2]
        default:
            categoryOneLabel.isHidden = true
            categoryTwoLabel.isHidden = true
            categoryThreeLabel.isHidden = true
            noCaterogiesAvailableLabel.isHidden = false
            noCaterogiesAvailableLabel.text = "No categories available."
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFavoriteToMap" {
            guard let destinationVC = segue.destination as? FavoriteMapViewController,
                let restaurant = restaurant else { return }
            
            destinationVC.restaurant = restaurant
        }
        
    }

}

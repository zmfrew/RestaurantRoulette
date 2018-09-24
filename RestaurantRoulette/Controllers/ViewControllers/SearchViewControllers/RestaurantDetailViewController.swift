//
//  RestaurantDetailViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/24/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class RestaurantDetailViewController: UIViewController {
    
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
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    // MARK: - Properties
    var business: CDYelpBusiness? {
        didSet {
            restaurant = RestaurantController.shared.addRestaurantFrom(business: business!)
        }
    }
    var restaurant: Restaurant? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    // MARK: - LifeCycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ButtonAnimationManager.moveButtonsOffScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ButtonAnimationManager.animateButtonOntoScreen(leftButton: searchButton, centerButton: nil, rightButton: favoritesButton)
        StoreReviewManager.shared.showReview()
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func phoneNumberButtonTapped(_ sender: UIButton) {
        guard let restaurant = restaurant,
            let phoneNumber = restaurant.phoneNumber else { return }
        
        if let url = URL(string: "tel://\(phoneNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("This phone number doesn't work.")
            }
        }
    }
    
    @IBAction func unwindToSearchFromMap(unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToSearchFromMapToBookmarks(unwindSegue: UIStoryboardSegue) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    private func updateViews() {
        guard let restaurant = restaurant else { return }
        guard let imageURLAsString = restaurant.imageURLAsString,
            let imageURL = URL(string: imageURLAsString),
            let imageData = try? Data(contentsOf: imageURL)
            else {
                print("Error occurred creating images.")
                return
        }
        
        restaurantImageView.image = UIImage(data: imageData) ?? UIImage(named: "icon")
        
        restaurantImageView.layer.cornerRadius = restaurantImageView.layer.frame.height / 2
        hideStarsIfNecessary(restaurant.rating?.count ?? 0)
        
        let categoryLabels = restaurant.categories?.components(separatedBy: " ") ?? ["No categories available."]
        updateCategoryLabels(categoryLabels)
        
        let phoneNumber = PhoneNumberFormatter.formatPhoneNumber(restaurant.phoneNumber)
        phoneNumberButton.setTitle(phoneNumber, for: UIControlState())
        
        let isPhoneNumberButtonEnabled = phoneNumber == "No phone number available" ? false : true
        phoneNumberButton.isEnabled = isPhoneNumberButtonEnabled
        phoneNumberButton.tintColor = isPhoneNumberButtonEnabled == true ? UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 100) : UIColor(red: 115/255.0, green: 113/255.0, blue: 115/255.0, alpha: 100)
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
            
            destinationVC.title = restaurant.name
            destinationVC.restaurant = restaurant
        }
        
    }
    



}

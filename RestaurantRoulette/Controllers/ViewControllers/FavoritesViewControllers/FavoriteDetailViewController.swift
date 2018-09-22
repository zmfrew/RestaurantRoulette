//
//  FavoriteDetailViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CloudKit

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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    // MARK: - Properties
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
        ButtonAnimationManager.moveButtonsOffScreen(leftButton: searchButton, centerButton: locationButton, rightButton: favoritesButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ButtonAnimationManager.animateButtonOntoScreen(leftButton: searchButton, centerButton: locationButton, rightButton: favoritesButton)
    }
    
    // MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        guard let restaurant = restaurant else { return }
        
        // Create CloudKit record and save when the shareButton is tapped. Following sharing with another user, the record is deleted to clear out room in the user's iCloud.
        let record = CKRecord(restaurant: restaurant)
        
        // Check if the user is signed into CloudKit. If they are, create the record and share it.
        CKContainer.default().accountStatus { accountStatus, error in
            if accountStatus == .noAccount {
                let alert = UIAlertController(title: "Sign in to iCloud", message: "Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                
                CloudKitManager.shared.save(ckRecord: record) { (restaurant) in
                    if let restaurant = restaurant {
                        
                        let shareContextualAction = UIContextualAction(style: .normal, title: "Share") { (action, view, nil) in
                            // Create cloud sharing container.
                            let cloudSharingContainer = UICloudSharingController { (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
                                
                                CloudKitManager.shared.createShare(with: restaurant, completion: completion)
                            }
                            
                            if let popover = cloudSharingContainer.popoverPresentationController {
                                popover.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                            }
                            DispatchQueue.main.async {
                                self.present(cloudSharingContainer, animated: true)
                            }
                        }
                        
                        shareContextualAction.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//                        let configuration = UISwipeActionsConfiguration(actions: [shareContextualAction])
//                        configuration.performsFirstActionWithFullSwipe = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                            CloudKitManager.shared.delete(restaurant: restaurant, completion: { (success) in
                                if success {
                                    print("Deleted from CloudKit 10 after adding to allow time for CKShare.")
                                }
                            })
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
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
        // FIXME: - Update default image to show in favorites.
        restaurantImageView.image = UIImage(data: imageData) ?? UIImage(named: "mockShannons")
        
        restaurantImageView.layer.cornerRadius = restaurantImageView.layer.frame.height / 2
        hideStarsIfNecessary(restaurant.rating?.count ?? 0)
        
        let categoryLabels = restaurant.categories?.components(separatedBy: " ") ?? ["No categories available."]
        updateCategoryLabels(categoryLabels)
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

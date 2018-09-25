//
//  InitialOnboardingViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/25/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class InitialOnboardingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var onboardingContainer: UIView!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Actions
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        sender.removeFromSuperview()
        onboardingContainer.removeFromSuperview()
    }
    
}

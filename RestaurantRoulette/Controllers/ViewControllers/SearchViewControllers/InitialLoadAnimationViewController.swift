//
//  InitialLoadAnimationViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/24/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class InitialLoadAnimationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AnimationManager.rotate(iconImageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.performSegue(withIdentifier: "animationLoadToSearch", sender: nil)
        })
    }

}

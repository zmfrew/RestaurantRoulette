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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rotateAnimation(view: iconImageView)
    }
    
    // MARK: - Methods
    func rotateAnimation(view: UIView ,duration: CFTimeInterval = 2.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        
        view.layer.add(rotateAnimation, forKey: nil)
    }

}

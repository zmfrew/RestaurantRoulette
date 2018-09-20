//
//  RouletteAnimationViewController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class RouletteAnimationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var rouletteCircle: UIView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRouletteCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rotateAnimation(view: rouletteCircle)
    }
    
    // MARK: - Methods
    func setupRouletteCircle() {
        rouletteCircle.layer.cornerRadius = rouletteCircle.layer.frame.height / 2
    }
    
    func rotateAnimation(view: UIView ,duration: CFTimeInterval = 2.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        
        view.layer.add(rotateAnimation, forKey: nil)
    }

}

//
//  ButtonAnimationManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class AnimationManager {
    
    static func moveButtonsOffScreen(leftButton: UIButton, centerButton: UIButton?, rightButton: UIButton) {
        guard let centerButton = centerButton else { return }
        
        DispatchQueue.main.async {
            leftButton.center.x = leftButton.center.x - 100
            centerButton.center.y = centerButton.center.y + 100
            rightButton.center.x = rightButton.center.x + 100
        }
    }
    
    static func animateButtonOntoScreen(leftButton: UIButton, centerButton: UIButton?, rightButton: UIButton) {
        guard let centerButton = centerButton else { return }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                leftButton.center.x = leftButton.center.x + 100
                rightButton.center.x = rightButton.center.x - 100
            }, completion: nil)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
                centerButton.center.y = centerButton.center.y - 100
            }, completion: nil)
        }
    }
    
    static func rotate(_ view: UIView, duration: CFTimeInterval = 2.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        DispatchQueue.main.async {
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(.pi * 2.0)
            rotateAnimation.duration = duration
            rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
            view.layer.add(rotateAnimation, forKey: nil)
        }
    }
    
}

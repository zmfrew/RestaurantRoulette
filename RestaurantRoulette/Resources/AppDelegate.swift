//
//  AppDelegate.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        CDYelpFusionKitManager.shared.configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "SearchScreen", bundle: nil)
        var initialViewController: UIViewController
        
        if StoreReviewManager.shared.getRunCounts() == 0 {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialOnboardingViewController")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialLoadAnimationViewController")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        StoreReviewManager.shared.incrementAppRuns()
        
        return true
    }
    
}


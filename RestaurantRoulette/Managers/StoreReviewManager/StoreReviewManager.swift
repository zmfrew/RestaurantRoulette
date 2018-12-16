//
//  StoreReviewManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/24/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import StoreKit

class StoreReviewManager {
    
    // MARK: - Singleton
    static let shared = StoreReviewManager(); private init() { }
    
    // MARK: - Properties
    let runIncrementerSetting = "numberOfRuns"
    let minimumRunCount = 7
    
    // MARK: - Methods
    func incrementAppRuns() {                   
        let usD = UserDefaults()
        let runs = getRunCounts() + 1
        usD.setValuesForKeys([runIncrementerSetting: runs])
        usD.synchronize()
    }
    
    func getRunCounts () -> Int {
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: runIncrementerSetting)
        var runs = 0
        
        if (savedRuns != nil) {
            runs = savedRuns as! Int
        }
        
        return runs
    }
    
    func showReview() {
        let runs = getRunCounts()
        
        if (runs > minimumRunCount) {
            if #available(iOS 10.3, *) {
                print("Review Requested")
                SKStoreReviewController.requestReview()
            }
        }
    }
}

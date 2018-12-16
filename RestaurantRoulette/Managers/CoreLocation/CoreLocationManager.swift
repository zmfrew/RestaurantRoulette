//
//  CoreLocationManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    // MARK: - Singleton
    static let shared = CLLocationManager(); private init() { }
    
}

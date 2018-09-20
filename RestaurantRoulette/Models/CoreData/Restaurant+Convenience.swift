//
//  Restaurant+Convenience.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import MapKit
import CoreData
import Foundation

// Extension to initialize  CoreData properties.
extension Restaurant {
    
    convenience init(name: String, imageURLAsString: String?, rating: String?, categories: String?, phoneNumber: String?, latitude: Double?, longitude: Double?, isFavorite: Bool = true, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.imageURLAsString = imageURLAsString
        self.rating = rating
        self.categories = categories
        self.phoneNumber = phoneNumber
        
        guard let latitude = latitude,
            let longitude = longitude
            else { return }
        
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.timestamp = timestamp
    }
    
}

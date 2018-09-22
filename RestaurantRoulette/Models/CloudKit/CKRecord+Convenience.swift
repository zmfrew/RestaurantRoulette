//
//  CKRecord+Convenience.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/22/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    
    convenience init(restaurant: Restaurant) {
        let ckRecordID = restaurant.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Restaurant.typeKey, recordID: ckRecordID)
        self.setValue(restaurant.title, forKey: Restaurant.nameKey)
        self.setValue(restaurant.name, forKey: Restaurant.nameKey)
        self.setValue(restaurant.imageURLAsString, forKey: Restaurant.imageURLAsStringKey)
        self.setValue(restaurant.rating, forKey: Restaurant.ratingKey)
        self.setValue(restaurant.categories, forKey: Restaurant.categoriesKey)
        self.setValue(restaurant.phoneNumber, forKey: Restaurant.phoneNumberKey)
        self.setValue(restaurant.latitude, forKey: Restaurant.latitudeKey)
        self.setValue(restaurant.longitude, forKey: Restaurant.longitudeKey)
        self.setValue(restaurant.isFavorite, forKey: Restaurant.isFavoriteKey)
        self.setValue(restaurant.timestamp, forKey: Restaurant.timestampKey)
        restaurant.cloudKitRecordIDString = recordID.recordName
    }
    
}

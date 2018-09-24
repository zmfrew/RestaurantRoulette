//
//  Restaurant+CoreDataClass.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/22/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import MapKit
import CoreData
import CloudKit
import Contacts
import Foundation

@objc(Restaurant)
public class Restaurant: NSManagedObject, MKAnnotation {
    
    // MARK: - CloudKit Properties
    var recordType: String {
        return Restaurant.typeKey
    }
    
    var cloudKitRecordID: CKRecordID? {
        guard let recordIDString = cloudKitRecordIDString else { print("no cloudKitrecordIDString exists."); return nil }
        
        return CKRecordID(recordName: recordIDString)
    }
    
    var reference: CKReference? {
        guard let cloudKitRecordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: cloudKitRecordID, action: .deleteSelf)
    }
    
    // MARK: - MKAnnotation Properties
    // Property must be public to satisfy MKAnnotation protocol
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    
    // MARK: - Initializers
    convenience init(name: String, imageURLAsString: String?, rating: String?, categories: String?, phoneNumber: String?, latitude: Double?, longitude: Double?, isFavorite: Bool = true, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = name
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
    
    required convenience public init?(record: CKRecord, context: NSManagedObjectContext) {
        self.init(context: context)
        guard let name = record[Restaurant.nameKey] as? String,
            let imageURLAsString = record[Restaurant.imageURLAsStringKey] as? String,
            let rating = record[Restaurant.ratingKey] as? String,
            let categories = record[Restaurant.categoriesKey] as? String,
            let phoneNumber = record[Restaurant.phoneNumberKey] as? String,
            let latitude = record[Restaurant.latitudeKey] as? Double,
            let longitude = record[Restaurant.longitudeKey] as? Double,
            let isFavorite = record[Restaurant.isFavoriteKey] as? Bool,
            let timestamp = record[Restaurant.timestampKey] as? NSDate
            else { return nil }
        
        self.title = name
        self.name = name
        self.imageURLAsString = imageURLAsString
        self.rating = rating
        self.categories = categories
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
        self.timestamp = timestamp
        self.cloudKitRecordIDString = record.recordID.recordName
    }
    
    // MARK: - Methods
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: self.name]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }
    
}

extension Restaurant {
    
    // MARK: - Constant Keys
    static let typeKey = "Restaurant"
    static let nameKey = "name"
    static let titleKey = "title"
    static let imageURLAsStringKey = "imageURLAsString"
    static let ratingKey = "rating"
    static let categoriesKey = "categories"
    static let phoneNumberKey = "phoneNumber"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let isFavoriteKey = "isFavorite"
    static let timestampKey = "timestamp"
    
}

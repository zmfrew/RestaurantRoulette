//
//  Restaurant+Convenience.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import MapKit
import CoreData
import Contacts
import Foundation

// Extension to initialize  CoreData properties.
extension Restaurant: MKAnnotation {
    
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
    
    // Property must be public to satisfy MKAnnotation protocol
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
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

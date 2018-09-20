//
//  MockRestaurant.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class MockRestaurant: NSObject, MKAnnotation {
    
    // MARK: - Properties
    @objc var title: String?
    var name: String
    var rating: Int
    var image: UIImage
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double
    var phoneNumber: String
    var categories: [String]
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Intializers
    init(name: String, rating: Int, image: UIImage, isFavorite: Bool, latitude: Double, longitude: Double, phoneNumber: String, categories: [String]) {
        self.title = name
        self.name = name
        self.rating = rating
        self.image = image
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.categories = categories
    }
    
    // MARK: - Methods
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: self.name]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }

}

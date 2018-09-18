//
//  MockRestaurant.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class Restaurant {
    
    // MARK: - Properties
    var name: String
    var rating: Int
    var image: UIImage
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double
    var phoneNumber: String
    var categories: [String]
    
    // MARK: - Intializers
    init(name: String, rating: Int, image: UIImage, isFavorite: Bool, latitude: Double, longitude: Double, phoneNumber: String, categories: [String]) {
        self.name = name
        self.rating = rating
        self.image = image
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.categories = categories
    }

}

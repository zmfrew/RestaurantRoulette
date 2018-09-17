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
    
    // MARK: - Intializers
    init(name: String, rating: Int, image: UIImage, isFavorite: Bool) {
        self.name = name
        self.rating = rating
        self.image = image
        self.isFavorite = isFavorite
    }

}

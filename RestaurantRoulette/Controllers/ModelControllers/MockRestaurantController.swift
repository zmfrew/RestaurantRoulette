//
//  MockRestaurantController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class RestaurantController {
    
    // MARK: - Singleton
    static let shared = RestaurantController()
    
    // MARK: - DataSource
    var restaurants: [Restaurant] = [
        Restaurant(name: "RamenYum", rating: 4, image: UIImage(named: "mockRamen")!, isFavorite: false),
        Restaurant(name: "Peel Pizza", rating: 5, image: UIImage(named: "mockPizza")!, isFavorite: true),
        Restaurant(name: "Buffalo Wild Wings", rating: 2, image: UIImage(named: "mockWings")!, isFavorite: false),
        Restaurant(name: "Robin's Nest", rating: 5, image: UIImage(named: "mockSandwich")!, isFavorite: true),
        Restaurant(name: "Cleveland Heath", rating: 5, image: UIImage(named: "mockCleveland")!, isFavorite: true),
        Restaurant(name: "Mike Shannon's", rating: 5, image: UIImage(named: "mockShannons")!, isFavorite: true)
    ]
    
}

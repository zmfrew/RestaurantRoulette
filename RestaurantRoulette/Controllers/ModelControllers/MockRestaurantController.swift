//
//  MockRestaurantController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class MockRestaurantController {
    
    // MARK: - Singleton
    static let shared = MockRestaurantController()
    
    // MARK: - DataSource
    var restaurants: [MockRestaurant] = [
        MockRestaurant(name: "RamenYum", rating: 4, image: UIImage(named: "mockRamen")!, isFavorite: false, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Traditional", "Asain", "Fusion"]),
        MockRestaurant(name: "Peel Pizza", rating: 5, image: UIImage(named: "mockPizza")!, isFavorite: true, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Pizza", "Wings", "Bar"]),
        MockRestaurant(name: "Buffalo Wild Wings", rating: 2, image: UIImage(named: "mockWings")!, isFavorite: false, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Sports bar", "American (traditional)"]),
        MockRestaurant(name: "Robin's Nest", rating: 5, image: UIImage(named: "mockSandwich")!, isFavorite: true, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Sandwiches"]),
        MockRestaurant(name: "Cleveland Heath", rating: 5, image: UIImage(named: "mockCleveland")!, isFavorite: true, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Fusion", "Gastropub"]),
        MockRestaurant(name: "Mike Shannon's", rating: 5, image: UIImage(named: "mockShannons")!, isFavorite: true, latitude: 40.7618, longitude: 111.8907, phoneNumber: "+12345678901", categories: ["Burgers", "American (traditional)"])
    ]
    
}

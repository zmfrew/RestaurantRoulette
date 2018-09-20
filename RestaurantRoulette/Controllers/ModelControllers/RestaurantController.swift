//
//  RestaurantController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import CoreData
import Foundation

class RestaurantController {
    
    // MARK: - Singleton
    static let shared = RestaurantController()
    
    // MARK: - DataSource
    let fetchedResultsController: NSFetchedResultsController<Restaurant> = {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    // MARK: - Methods
    func addRestaurant(name: String, imageURLAsString: String?, rating: String?, categories: String?, phoneNumber: String?, latitude: Double?, longitude: Double?) {
        _ = Restaurant(name: name, imageURLAsString: imageURLAsString, rating: rating, categories: categories, phoneNumber: phoneNumber, latitude: latitude, longitude: longitude)
        // Do not need to create then convert to CKRecord to save to CoreData & CloudKit. Only need to create as a CKRecord, and CoreData will save it automatically.
        CoreDataManager.save()
    }
    
    func delete(_ restaurant: Restaurant) {
        CoreDataManager.delete(restaurant)
        // Delete from CloudKit if it exists.
    }
    
    // FIXME: - May be able to delete this function because I'm going to delete objects once they are no longer favorited.
    func toggleIsFavorite(restaurant: Restaurant) {
        restaurant.isFavorite = !restaurant.isFavorite
        CoreDataManager.save()
    }
    
    func fetchAllRestaurants() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error occurred while fetching data from CoreData: \(error.localizedDescription).")
        }
    }
    
}

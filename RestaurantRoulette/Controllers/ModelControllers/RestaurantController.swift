//
//  RestaurantController.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import CoreData
import CloudKit
import Foundation
import CDYelpFusionKit

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
        // Do not need to create then convert to CKRecord to save to CoreData & CloudKit. Only need to create as a CKRecord, and CoreData will save it automatically.
        let record = CKRecord(restaurant: Restaurant(name: name, imageURLAsString: imageURLAsString, rating: rating, categories: categories, phoneNumber: phoneNumber, latitude: latitude, longitude: longitude))
        CloudKitManager.shared.save(ckRecord: record) { (record) in
        }
        CoreDataManager.save()
    }
    
    func addRestaurantFrom(business: CDYelpBusiness) -> Restaurant? {
        guard let name = business.name else { return nil }
        
        guard let imageURLAsString = business.imageUrl?.absoluteString,
            let rating = business.rating?.description,
            let yelpCategories = business.categories,
            let phoneNumber = business.phone,
            let latitude = business.coordinates?.latitude,
            let longitude = business.coordinates?.longitude
            else { return nil }
        
        let categories = yelpCategories.map { "\($0.title ?? "")" }.joined(separator: " ")
        
        let restaurant = Restaurant(name: name, imageURLAsString: imageURLAsString, rating: rating, categories: categories, phoneNumber: phoneNumber, latitude: latitude, longitude: longitude)
        let record = CKRecord(restaurant: restaurant)
        CloudKitManager.shared.save(ckRecord: record) { (_) in
        }
        CoreDataManager.save()
        
        return restaurant
    }
    
    func delete(_ restaurant: Restaurant) {
        CoreDataManager.delete(restaurant)
        // Delete from CloudKit if it exists.
        CloudKitManager.shared.delete(restaurant: restaurant) { (_) in
        }
        CoreDataManager.save()
    }
    
//    // FIXME: - May be able to delete this function because I'm going to delete objects once they are no longer favorited.
//    func toggleIsFavorite(restaurant: Restaurant) {
//        restaurant.isFavorite = !restaurant.isFavorite
//        CoreDataManager.save() 
//    }
    
    func fetchAllRestaurants() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error occurred while fetching data from CoreData: \(error.localizedDescription).")
        }
    }
    
    func isBusinessAFavorite(business: CDYelpBusiness?) -> Bool {
        guard let business = business else { return false }
        guard let restaurants = fetchedResultsController.fetchedObjects else { return false }
        
        for restaurant in restaurants {
            if isBusinessARestaurant(business: business, restaurant: restaurant) {
                return true
            }
        }
        
        return false
    }
    
    private func isBusinessARestaurant(business: CDYelpBusiness, restaurant: Restaurant) -> Bool {
        return business.name == restaurant.name && business.rating?.description == restaurant.rating && business.phone == restaurant.phoneNumber
    }
    
    func getRestaurantCorrespondingToBusinees(business: CDYelpBusiness) -> Restaurant? {
        guard let restaurants = fetchedResultsController.fetchedObjects else { return nil }
        for restaurant in restaurants {
            if isBusinessARestaurant(business: business, restaurant: restaurant) {
                return restaurant
            }
        }
        return nil
    }
    
}

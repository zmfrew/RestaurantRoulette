//
//  CoreDataManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    
    // MARK: - Methods
    static func delete(_ object: Restaurant) {
        object.managedObjectContext?.delete(object)
        save()
    }
    
    // MARK: - Persistence
    static func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error occured saving data to CoreData: \(error.localizedDescription).")
        }
    }
    
}

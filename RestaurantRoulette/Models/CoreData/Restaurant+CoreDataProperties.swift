//
//  Restaurant+CoreDataProperties.swift
//
//
//  Created by Zachary Frew on 9/22/18.
//
//

import CoreData
import Foundation

extension Restaurant {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }
    
    @NSManaged public var categories: String?
    @NSManaged public var imageURLAsString: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var rating: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var cloudKitRecordIDString: String?
    
}

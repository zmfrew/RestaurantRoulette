//
//  CloudKitManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class CloudKitManager {
    
    // MARK: - Singleton
    static let shared = CloudKitManager()
    
    // MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - Methods
    func save(ckRecord: CKRecord, completion: @escaping (Restaurant?) -> Void) {
        privateDB.save(ckRecord) { (record, error) in
            if let error = error {
                print("Error occurred saving to CloudKit: \(error.localizedDescription).")
                completion(nil)
                return
            }
            
            guard let record = record else { completion(nil); return }
            let restaurant = Restaurant(record: record, context: NSManagedObjectContext())
            print("Successfully saved to CloudKit.")
            completion(restaurant)
        }
    }
    
    func delete(restaurant: Restaurant, completion: @escaping(Bool) -> Void) {
        guard let recordIDString = restaurant.cloudKitRecordIDString else { completion(false); print("Tried to delete, but there's no cloudKitRecordID"); return }
        
        let recordID = CKRecordID(recordName: recordIDString)
        
        privateDB.delete(withRecordID: recordID) { (record, error) in
            if let error = error {
                print("Error occurred deleting restaurant: \(error.localizedDescription).")
                completion(false)
                return
            }
            print("Deleted from CloudKit.")
            completion(true)
        }
    }
    
    func createShare(with restaurant: Restaurant, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) {
        let rootRecord = CKRecord(restaurant: restaurant)
        let shareRecord = CKShare(rootRecord: rootRecord)
        let operation = CKModifyRecordsOperation(recordsToSave: [shareRecord, rootRecord], recordIDsToDelete: nil)
        operation.perRecordCompletionBlock = { (record, error) in
            if let error = error {
                print("Error occurred sharing: \(error.localizedDescription)")
                completion(nil, nil, error)
            }
        }
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, error) in
            if let error = error {
                print("Error occurred sharing: \(error.localizedDescription)")
                completion(nil, nil, error)
            } else {
                completion(shareRecord, CKContainer.default(), nil)
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
}

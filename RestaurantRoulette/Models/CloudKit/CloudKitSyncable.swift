//
//  CloudKitSyncable.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/22/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import CoreData
import CloudKit
import Foundation

protocol CloudKitSyncable {
    
    // MARK: - Properties
    var cloudKitRecordIDString: String? { get set }
    var recordType: String { get }
    var cloudKitRecordID: CKRecordID? { get }
    var reference: CKReference? { get }
    
}

extension CloudKitSyncable {
    
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .none)
    }
    
}

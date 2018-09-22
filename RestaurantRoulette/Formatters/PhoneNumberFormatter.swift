//
//  PhoneNumberFormatter.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

class PhoneNumberFormatter {
    
    static func formatPhoneNumber(_ string: String?) -> String {
        guard let string = string, string.count-1 == 11 else { return "No phone number available" }
        
        let stringArr = Array(string.replacingOccurrences(of: "+", with: ""))
        return "\(stringArr[0]) (\(stringArr[1])\(stringArr[2])\(stringArr[3])) \(stringArr[4])\(stringArr[5])\(stringArr[6])-\(stringArr[7])\(stringArr[8])\(stringArr[9])\(stringArr[10])"
    }
    
}

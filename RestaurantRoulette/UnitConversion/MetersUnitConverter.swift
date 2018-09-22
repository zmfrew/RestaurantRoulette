//
//  MetersUnitConverter.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/17/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation

class MetersUnitConverter: UnitConverter {
    
    static func convertMilesToMetersAsInt(from distance: Double) -> Int {
        let distance = Measurement(value: distance, unit: UnitLength.miles)
        return Int(distance.converted(to: UnitLength.meters).value)
    }
    
}

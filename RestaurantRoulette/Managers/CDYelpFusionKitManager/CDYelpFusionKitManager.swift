//
//  CDYelpFusionKitManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CDYelpFusionKit

final class CDYelpFusionKitManager: NSObject {
    
    static let shared = CDYelpFusionKitManager()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {
        self.apiClient = CDYelpAPIClient(apiKey: "I0qSH8J_7lXbRGPRmvDDIVvt-Ockn0QVow5rbUCzUsU7G7QaQRf0z_lzlwkmPvF-DJcFasUx2zat3gucHCLA6kmZ8XXdiIwJXmAw__NUfmVUFW6bx713FjnLQFiRW3Yx")
    }
    
    
    func setPriceTierForSearch(_ price: String?) -> [CDYelpPriceTier]? {
        guard let price = price else { return nil }
        switch price {
        case "$":
            return [CDYelpPriceTier.oneDollarSign]
        case "$$":
            return [CDYelpPriceTier.oneDollarSign, CDYelpPriceTier.twoDollarSigns]
        case "$$$":
            return [CDYelpPriceTier.oneDollarSign, CDYelpPriceTier.twoDollarSigns, CDYelpPriceTier.threeDollarSigns]
        case "$$$$":
            return [CDYelpPriceTier.oneDollarSign, CDYelpPriceTier.twoDollarSigns, CDYelpPriceTier.threeDollarSigns, CDYelpPriceTier.fourDollarSigns]
        default:
            return [CDYelpPriceTier.oneDollarSign, CDYelpPriceTier.twoDollarSigns, CDYelpPriceTier.threeDollarSigns, CDYelpPriceTier.fourDollarSigns]
        }
    }
    
}

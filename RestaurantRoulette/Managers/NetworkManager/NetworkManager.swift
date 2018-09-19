//
//  NetworkManager.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/19/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CDYelpFusionKit

class NetworkManager {
    
    static func searchForBusinessesBy(searchTerm: String?, location: String?, latitude: Double?, longitude: Double?, locationRadius: Int?, price: String?, openNow: Bool?) -> [CDYelpBusiness] {
        let priceTiers = NetworkManager.setPriceTierForSearch(price)
        
        
        CDYelpFusionKitManager.shared.apiClient.searchBusinesses(byTerm: searchTerm, location: location, latitude: latitude, longitude: longitude, radius: locationRadius, categories: nil, locale: nil, limit: 50, offset: nil, sortBy: CDYelpBusinessSortType.bestMatch, priceTiers: priceTiers, openNow: openNow, openAt: nil, attributes: nil) { (response) in
            var yelpBusinesses: [CDYelpBusiness] = []
            
            if let response = response, let businesses = response.businesses {
                yelpBusinesses = businesses
            } else {
                ErrorManager.presentSearchError()
            }
        }
    }
    
    static func setPriceTierForSearch(_ price: String?) -> [CDYelpPriceTier]? {
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

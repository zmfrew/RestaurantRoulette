//
//  CDYelpBusiness+MKAnnotation.swift
//  RestaurantRoulette
//
//  Created by Zachary Frew on 9/18/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import MapKit
import Contacts
import Foundation
import CDYelpFusionKit

// MARK: - MKAnnotationand NSObject Conformance
extension CDYelpBusiness: MKAnnotation {
    
    // MARK: - Properties
    public var coordinate: CLLocationCoordinate2D {
        guard let latitude = self.coordinates?.latitude,
            let longitude = self.coordinates?.longitude
            else {
                return CLLocationCoordinate2D(latitude: 38.627003, longitude: -90.199402)
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Methods
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: self.name ?? "Restaurant"]
        var coordinate: CLLocationCoordinate2D
        if let businessCoordinate = self.coordinates, let latitude = businessCoordinate.latitude, let longitude = businessCoordinate.longitude {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 38.627003, longitude: -90.199402)
        }
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }
    
}

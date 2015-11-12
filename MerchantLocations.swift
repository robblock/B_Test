//
//  MerchantLocations.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import MapKit

class MerchantLocations: NSObject {
    let merchant: String
    let hours: String
    let coordinate: CLLocationCoordinate2D
    
    init(merchant: String, hours: String, coordinate: CLLocationCoordinate2D) {
        self.merchant = merchant
        self.hours = hours
        self.coordinate = coordinate
        
        super.init()
    }
    
    class func fromJson(json: NSArray) -> MerchantLocations? {
        var latitude: Double? = nil
        if let latString = json[23] as? NSString {
            latitude = latString.doubleValue
        }
        
        var longitude: Double? = nil
        if let longString = json[24] as? NSString {
            longitude = longString.doubleValue
        }
     return nil
    }
    
    
    
}
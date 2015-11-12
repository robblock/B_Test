//
//  UserLocation.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    internal class UserLocationManager: NSObject, CLLocationManagerDelegate {
        
        
        var locationManager:CLLocationManager = CLLocationManager()
        
        var longitude: Double!
        var latitude: Double!
        
        private var requested:Bool = false
        
        func requestedLocation() {
            if self.requested {
                return
            }
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.requested = true
        }
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("error: \(error)")
        }
        
        
        
        class var instance: UserLocationManager {
            struct Static {
                static let instance: UserLocationManager = UserLocationManager()
            }
            return Static.instance
        }
    }
    
    var manager: UserLocationManager!
    
    override init() {
        manager = UserLocationManager.instance
    }
    
    var latitude: Double {
        get {
            return manager.latitude ?? 37.7710347
        }
    }
    
    var longitude: Double {
        get {
            return manager.longitude ?? -122.4040795
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
}

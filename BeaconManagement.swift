//
//  BeaconManagement.swift
//  beacons_test
//
//  Created by Rob Block on 11/18/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManagement: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let colors = [
        54482: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        31351: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        27327: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    //Grab the first element in the beacon array
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0 ) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
        }
    }
    
    
    
    
    
    
}
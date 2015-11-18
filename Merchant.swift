//
//  Merchant.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import Parse

class Merchant {
    
    var dictionary: NSDictionary
    var allMerchantsArray: NSArray
    
    init(dictionary: NSDictionary, allMerchantsArray: NSArray) {
        self.dictionary = dictionary
        self.allMerchantsArray = allMerchantsArray
    }
    
    class func getMerchants(classNameString: String, objectString: String, var array: [String]) {
        
        let query = PFQuery(className: classNameString)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let merchantName = object[objectString] as? String
                    array.append(merchantName!)
                    
                }
                
                //self.tableView.reloadData()
            }
        }
        
    }
    

    




    var name: String {
        get {
            return self.dictionary["name"] as! String
        }
    }
    

    var deals: Array<AnyObject>? {
        get {
            if let deals = self.dictionary["deals"] as? Array<AnyObject> {
                return deals
            }
            return nil
        }
    }
    
    var latitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["latitude"] as! Double)
                }
            }
            return nil
        }
    }
    
    var longitude: Double? {
        get {
            if let location = self.dictionary["location"] as? NSDictionary {
                if let coordinate = location["coordinate"] as? NSDictionary {
                    return (coordinate["longitude"] as! Double)
                }
            }
            return nil
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        }
    }
    
    
    

    
}
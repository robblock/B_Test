//
//  PreferredOrderTableViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/13/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit



/* Notes:
                                
    When the user clicks on the preferredOrderCell from the profileView, they will be taken to this tableView which will display a list of merchants. When the user selects a merchant, they will be taken to detailViewController where they will be presented with the details of the merchant & be able to select their preferred order for that merchant. 

*/

class PreferredOrderTableViewController: UITableViewController {

    var merchantObject = [PFObject]()
    var merchantLocation = PFGeoPoint()

    var optionsArray = [String]()
    
    var merchantName = String()
    var merchantAddress = String()
    
    let parseHelper = ParseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Order_Options")
        query.includeKey("merchant")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects {
                        self.merchantObject = completeMerchantObject
                        //print(self.merchantObject)
                    }
                    if let optionsArrayObject = objects {
                        let options = object["options_array"] as? [String]
                        self.optionsArray = options!
                        print(self.optionsArray)
                    }
                    if let merchantNameObject:PFObject = object["merchant"] as? PFObject {
                        let merchant = merchantNameObject["restaurant_name"] as! String
                        let geo = merchantNameObject["Location"] as! PFGeoPoint
                        self.merchantLocation = geo
                        
                        self.merchantName = merchant
                        print(self.merchantName)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        
        var nib = UINib(nibName: "PreferedTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        let aLocation: CLLocationCoordinate2D = self.merchantLocation.location()
        let aLocationLongitude = self.merchantLocation.longitude
        let aLocationLatitude = self.merchantLocation.latitude
        
        let clLocation: CLLocation = CLLocation(latitude: aLocationLatitude, longitude: aLocationLongitude)
        
        
        
        parseHelper.reverseGeocodeLocation(clLocation) { (placemark, error) -> Void in
            
            
        }
        

    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return merchantObject.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PreferedTableViewCell
        
        let merchant = merchantObject[indexPath.row] as PFObject
        let options = optionsArray[indexPath.row] as String
        
        
        cell.item_nameLabel.text = merchant.objectForKey("item_name") as? String
        cell.item_OptionsLabel.text = options
        cell.merchantNameLabel.text = merchantName

        return cell
    }



}

//
//  HomeViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI
import MapKit



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allMerchantsArray = [String]()
    var merchantObject = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let query = PFQuery(className: "Restaurants_Menus")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                    self.merchantObject = completeMerchantObject
                    print(self.merchantObject)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }

    
    //MARK: - TableView DataSource & Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchantObject.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let merchant = merchantObject[indexPath.row] as PFObject
        cell.textLabel?.text = merchant.objectForKey("restaurant_id") as? String
        
        //Sublabel should display distance from merchant
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell # \(indexPath.row)!")
        
        let index = self.tableView.indexPathForSelectedRow?.row
        let merchant = merchantObject[index!] as PFObject
        
        
        performSegueWithIdentifier("MerchantDetail", sender: self)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MerchantDetail") {
            if let nvc: DetailViewController = segue.destinationViewController as! DetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    let merchant = merchantObject[blogIndex] as PFObject
                    
                    nvc.merchantId = merchant.objectId!
                    nvc.merchantLocation = merchant.objectForKey("Location") as! PFGeoPoint
                }
                
                
            }
        }
    }

    //MARK: - JSON

    
    //MARK: - Actions & Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var merchantMapViewButton: UIButton!
 

    
}

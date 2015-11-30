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


enum ListType {
    case All
    case Favorite
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var merchantObject = [PFObject]()
    
    var segmentedControl = UISegmentedControl()
    var listType: ListType = .All

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        //Parse
        let query = PFQuery(className: "Restaurants_Menus")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                    self.merchantObject = completeMerchantObject
                    //print(self.merchantObject)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        

        
        //SegmentController
        segmentedControl.selectedSegmentIndex = 0
        
        //DMZEmptyTableView
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
    }

    
    //MARK: - TableView DataSource & Delegate
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType {
            
        case .All:
            return merchantObject.count
        
        case .Favorite:
            return merchantObject.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        switch listType {
        case .All:
        let merchant = merchantObject[indexPath.row] as PFObject
        cell.textLabel?.text = merchant.objectForKey("restaurant_id") as? String
        //Sublabel should display distance from merchant
        case .Favorite:
        cell.textLabel!.text = "hello"
        }
        
        
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
            if let nvc: DetailViewController = segue.destinationViewController as? DetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    
                    let merchant = merchantObject[blogIndex] as PFObject
                    
                    nvc.merchantId = merchant.objectId!
                    nvc.merchantLocation = merchant.objectForKey("Location") as! PFGeoPoint
                    nvc.merchantName = merchant.objectForKey("restaurant_id") as! String

                }
            }
        }
    }

    //TODO: Add a liked/favorite merchant bar button (Example: All Merchants | Favorite) which will display only merchants the user has liked https://www.makeschool.com/tutorials/build-a-photo-sharing-app-part-1/organize-parse-query
    
    //MARK: - Segmented Controller
    
    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            listType = .All
        } else {
            listType = .Favorite
        }
        
        tableView.reloadData()
        
    }


    
    //MARK: - Actions & Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var merchantMapViewButton: UIButton!
 
    @IBOutlet weak var allFavoritesSegmentedControl: UISegmentedControl!

    
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Got Nothin")
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Sorry about this, I'm Just all out of data")
    }
}
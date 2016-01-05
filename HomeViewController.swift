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
import CoreLocation
import MMDrawerController


enum ListType {
    case All
    case Favorite
}

/*
Todo: 
    1. When the user likes a merchant, set a bool pointer in the Restaurant_Menus class, if the pointer is true, set likeIcon to selected.
    2. Signup Screen: http://cdn.pttrns.com/127/5432_f.jpg
    3. HomeScreen: Caviar
        Merchant Name
        Address
        Perfered Order 
        Photo of merchant
    4. Shopping Cart: http://cdn.pttrns.com/275/5165_f.jpg
    5. LefsideTableView: http://cdn.pttrns.com/366/5514_f.jpg

    rating system for wait time 
        https://github.com/glenyi/FloatRatingView
    menu button
        https://github.com/robb/hamburger-button




*/

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var merchantObject = [PFObject]()
    var likesObject = [PFObject]()

    var optionsItemName = String()
    var optionsItemArray = [String]()
    
    var segmentedControl = UISegmentedControl()
    
    
    var listType: ListType = .All

    let locationManager = CLLocationManager()
    
    var usersLocationGeoPoint = PFGeoPoint()
    let parseHelper = ParseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        print(PFUser.currentUser())
        
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("Login", sender: self)
        }
        
        //Parse
        let query = PFQuery(className: "Restaurants_Menus")
        query.includeKey("order_options")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                        self.merchantObject = completeMerchantObject
                    }
                    if let options:PFObject = object["order_options"] as? PFObject {
                        let id = options.objectId! as String
                        let itemName = options["item_name"] as!  String
                        let optionsArray = options["options_array"] as! [String]
                        
                        
                        self.optionsItemName = itemName
                        self.optionsItemArray = optionsArray
                        
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        
        let query2 = PFQuery(className: "Like")
        query2.fromLocalDatastore()
        query2.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject2 = objects! as? [PFObject] {
                       self.likesObject = completeMerchantObject2
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        

        //LocationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.usersLocationGeoPoint = geoPoint!
            }
        }
        
        //SegmentController
        segmentedControl.selectedSegmentIndex = 0
        
        //DMZEmptyTableView
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        let favNib = UINib(nibName: "HomeFavoritesTableViewCell", bundle: nil)
        tableView.registerNib(favNib, forCellReuseIdentifier: "Favorite")
    }
    

    

    //Navigation Bar
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
    }

    func customizeButton(button: UIButton) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
        
        
    }
    
    //MARK: - TableView DataSource & Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listType {
            
        case .All:
            return merchantObject.count
        
        case .Favorite:
            return likesObject.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        switch listType {
            
        case .All:
            let cellIdentifier = "Cell"
            let allCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
            let merchant = merchantObject[indexPath.row] as PFObject
            let distanceToMerchantLocation = merchant.objectForKey("Location") as! PFGeoPoint
            
            allCell.merchantNameLabel.text = merchant.objectForKey("restaurant_name") as? String
            allCell.preferedOrderLabel.text = optionsItemName
            allCell.preferedOptionsLabel.text = optionsItemArray.joinWithSeparator(" , ")
            
            allCell.distanceToMerchantLabel.text = ("\(distanceToMerchantLocation.distanceInMilesTo(usersLocationGeoPoint))")
            
            allCell.distanceImageView.image = UIImage(named: "point")
            
            return allCell
            
        case .Favorite:
            let cellIdentifier = "Favorite"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HomeFavoritesTableViewCell
            
            let likes:PFObject = self.likesObject[indexPath.row] as PFObject
            
            if let name = likes["toPost"] as? PFObject {
                if let restaurantName = name["restaurant_name"] as? String {
                    cell.merchantNameLabel.text = restaurantName
                }
            }
            
            if let location = likes["toPost"] as? PFObject {
                if let merchantLocation = location["Location"] as? PFGeoPoint {
                    
                    let aLongitutde = merchantLocation.longitude
                    let aLatitude = merchantLocation.latitude
                    let cllocation:CLLocation = CLLocation(latitude: aLatitude, longitude: aLongitutde)
                    
                    parseHelper.reverseGeocodeLocation(cllocation, completion: { (placemark, error) -> Void in
                        cell.merchantLocationLabel.text = self.parseHelper.addressFromPlacemark(placemark!)
                    })
                }
            }

            return cell
        }
        
        
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell # \(indexPath.row)!")
        
        switch listType {
            
        case .All:
        let index = self.tableView.indexPathForSelectedRow?.row
        let merchant = merchantObject[index!] as PFObject
        
        
        performSegueWithIdentifier("MerchantDetail", sender: self)
            
        case .Favorite:
            let index = self.tableView.indexPathForSelectedRow?.row
            let merchant = likesObject[index!] as PFObject
            
            performSegueWithIdentifier("FavoriteDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "MerchantDetail") {
            if let nvc: DetailViewController = segue.destinationViewController as? DetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    
                    let merchant = merchantObject[blogIndex] as PFObject
                    
                    nvc.merchantId = merchant.objectForKey("restaurant_id") as! String
                    nvc.merchantLocation = merchant.objectForKey("Location") as! PFGeoPoint
                    nvc.merchantName = merchant.objectForKey("restaurant_name") as! String
                    nvc.merchantObjId = merchant.objectId! as String
                }
            }
        }
        
        if (segue.identifier == "FavoriteDetail") {
            if let nvc: DetailViewController = segue.destinationViewController as? DetailViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    
                    let likes = likesObject[blogIndex] as PFObject
                    
                    if let location = likes["toPost"] as? PFObject {
                        if let restaurantName = location["restaurant_name"] as? String {
                            nvc.merchantName = restaurantName
                        }
                    }
                    if let location = likes["toPost"] as? PFObject {
                        if let restaurantName = location["restaurant_id"] as? String {
                            nvc.merchantId = restaurantName
                        }
                    }
                    if let location = likes["toPost"] as? PFObject {
                        nvc.merchantObjId = location.objectId! as String
                    }
                    if let location = likes["toPost"] as? PFObject {
                        if let restaurantName = location["Location"] as? PFGeoPoint {
                            nvc.merchantLocation = restaurantName
                        }
                    }
                }
            }
        }
        
        if (segue.identifier == "All") {
            if let nvc: HomeMapViewController = segue.destinationViewController as? HomeMapViewController {
                if let blogindex = tableView.indexPathForSelectedRow?.row {
                    let merchant = merchantObject[blogindex] as PFObject
                    
                    nvc.favoriteMerchants = merchant.objectForKey("Location") as! PFGeoPoint
                }
            }
        }
        
        if (segue.identifier == "Favorite") {
            if let nvc: HomeMapViewController = segue.destinationViewController as? HomeMapViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    let likes = likesObject[blogIndex]
                    
                    if let location = likes["toPost"] as? PFObject {
                        if let merchantLocation = location["Location"] as? PFGeoPoint {
                            nvc.favoriteMerchants = merchantLocation 
                        }
                    }
                    
                }
               
            }
        }

    }
    
    //MARK: - LocationManager
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error = \(error)")
    }
    
    
    //MARK: - Outlets & Actions
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var merchantMapViewButton: UIButton!
 
    @IBOutlet weak var allFavoritesSegmentedControl: UISegmentedControl!

    @IBAction func merchantMapViewButton(sender: AnyObject) {
        if (allFavoritesSegmentedControl.selectedSegmentIndex == 1) {
            performSegueWithIdentifier("Favorite", sender: self)
            
        } else {
            performSegueWithIdentifier("All", sender: self)
            
        }
    }
    
        @IBAction func segmentControlAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            listType = .All
        } else {
            listType = .Favorite
        }
        
        tableView.reloadData()
        
    }
    
        @IBAction func leftSideDrawerButton(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
}

//MARK: - DZNEMPTYTableView
extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

        
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "Got Nothin"
        
        var para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.ByWordWrapping
        para.alignment = NSTextAlignment.Center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFontOfSize(26),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Start drinkin more coffee bro"
        
        var para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.ByWordWrapping
        para.alignment = NSTextAlignment.Center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "I'm ready to get caffinated"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle("Pacifico"),
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
            
        ]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        print("button tapped")
        allFavoritesSegmentedControl.selectedSegmentIndex == 0
    }
}


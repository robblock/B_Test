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

        print(PFUser.currentUser())
        
        if PFUser.currentUser() == nil {
            performSegueWithIdentifier("Login", sender: self)
        }
        
        //Parse
        let query = PFQuery(className: "Restaurants_Menus")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                    self.merchantObject = completeMerchantObject
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
    
    //Navigation Bar
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        var nav = self.navigationController?.navigationBar
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
            return 0
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        switch listType {
            
        case .All:
        let merchant = merchantObject[indexPath.row] as PFObject
        cell.textLabel?.text = merchant.objectForKey("restaurant_name") as? String
        //Sublabel should display distance from merchant
            
        case .Favorite:
            return cell
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell # \(indexPath.row)!")
        
        switch listType {
            
        case .All:
        let index = self.tableView.indexPathForSelectedRow?.row
        let merchant = merchantObject[index!] as PFObject
        
        
        performSegueWithIdentifier("MerchantDetail", sender: self)
            
        case .Favorite: break
            
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
                    
                    
                    //let relation = merchant.relationForKey("restaurants_menus")
                    //nvc.testMenu = relation.valueForKey(merchant.objectId!) as! [PFObject]

                }
            }
        }
        
        if (segue.identifier == "All") {
            if let nvc: HomeMapViewController = segue.destinationViewController as? HomeMapViewController {
                if let blogindex = tableView.indexPathForSelectedRow?.row {
                    let merchant = merchantObject[blogindex] as PFObject
                    
                    nvc.allMerchants = merchant.objectForKey("Location") as! [PFGeoPoint]
                }
            }
        }
        
        if (segue.identifier == "Favorite") {
            if let nvc: HomeMapViewController = segue.destinationViewController as? HomeMapViewController {
               
                    
                
            }
        }

    }

    //MARK: - Segmented Controller
    @IBAction func segmentControlAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            listType = .All
        } else {
            listType = .Favorite
        }
        
        tableView.reloadData()
        
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
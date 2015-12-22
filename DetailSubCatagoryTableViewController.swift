//
//  DetailSubCatagoryTableViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/17/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class DetailSubCatagoryTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var merchantId = String()
    var menuCatagory = String()
    var merchantObjectId = String()
    var merchantObject = [PFObject]()
    var merchant = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "Restaurants_Menus_Catagories_Items")
        query.whereKey("restaurant_id", equalTo: merchantId)
        query.whereKey("catagory_id", equalTo: menuCatagory)
        query.includeKey("restaurant_name")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                        self.merchantObject = completeMerchantObject
                    }
                    if let merchant:PFObject = object["restaurant_name"] as? PFObject {
                        let name = merchant["restaurant_name"] as! String
                        let id = merchant.objectId! as String
                        self.merchantObjectId = id
                    }

                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    

    
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return merchantObject.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let menuObject = merchantObject[indexPath.row] as PFObject
        cell.textLabel!.text = menuObject.objectForKey("name") as? String

        
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedCellSourceView = tableView.cellForRowAtIndexPath(indexPath)
            
            var popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idPopover") as! PopoverViewController
            
            if let blogIndex = tableView.indexPathForSelectedRow?.row {
                let merchant = merchantObject[blogIndex] as PFObject
                popover.itemName = merchant.objectForKey("name") as! String
                
            }
            popover.merchantId = merchantId
            popover.menuCatagory = menuCatagory
            popover.merchantObjectId = merchantObjectId

            popover.modalPresentationStyle = UIModalPresentationStyle.Popover
            popover.popoverPresentationController?.delegate = self
            popover.popoverPresentationController?.sourceView = selectedCellSourceView
            popover.popoverPresentationController?.permittedArrowDirections = .Up
            popover.preferredContentSize = CGSizeMake(self.view.frame.width, 300)
            self.presentViewController(popover, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }


    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}




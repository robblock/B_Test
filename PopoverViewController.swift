//
//  PopoverViewController.swift
//  beacons_test
//
//  Created by Rob Block on 12/10/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {

    var merchantId = String()
    var menuCatagory = String()
    var merchantObject = [PFObject]()
    
    var sizingCell: TagCell?
    
    var tags = [Tag]()
    
    var optionsTags = ["Skim milk", "2% Milk", "Whole Milk", "Almond Milk", "Soy Milk", "Extra Shot", "Chocolate Syrup"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "Restaurant_Menus_Catagories_Items_Options")
        query.whereKey("merchant_id", equalTo: merchantId)
        query.whereKey("menu_catagory", equalTo: menuCatagory)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects! as? [PFObject] {
                        self.merchantObject = completeMerchantObject
                    }
                }

            }
        }
        
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.tagCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.tagCollectionView.backgroundColor = UIColor.clearColor()
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        for option in optionsTags {
            var tag = Tag()
            tag.name = option
            self.tags.append(tag)
        }
    }
    
    //MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsTags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
        self.configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        tagCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
        tags[indexPath.row].selected = tags[indexPath.row].selected
        self.tagCollectionView.reloadData()
    }
    
    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]
        cell.tagName.text = tag.name
    }
    
   override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    

    @IBAction func saveButtonAction(sender: AnyObject) {
        //Dismiss view & go back to homescreen
        var dismiss = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! HomeViewController
        self.presentViewController(dismiss, animated: true, completion: nil)
        
        quantityStepCounter.wraps = true
        quantityStepCounter.autorepeat = true
        quantityStepCounter.maximumValue = 10
    }
    
    
    @IBAction func stepperValueChange(sender: UIStepper) {
        quantityTextView.text = Int(sender.value).description
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var quantityTextView: UITextView!
    @IBOutlet weak var quantityStepCounter: UIStepper!
    

    @IBOutlet weak var closeButton: UIButton!
}


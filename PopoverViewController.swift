//
//  PopoverViewController.swift
//  beacons_test
//
//  Created by Rob Block on 12/10/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse

class PopoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate{

    
    var merchantId = String()
    var menuCatagory = String()
    var itemName = String()
    var merchantObjectId = String()
    
    var merchantObject = [PFObject]()
    
    var sizingCell: TagCell?
    
    var tags = [Tag]()

    var optionsTags = ["Skim milk", "2% Milk", "Whole Milk", "Almond Milk", "Soy Milk", "Extra Shot", "Chocolate Syrup"]
    
    //Array used to save options to parse
    var orderOptions = [String]()
    
    //Array used to store selected tags for the entire order
    var selectedTags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        print(merchantId)
        print(menuCatagory)
        print(itemName)
        
        let query = PFQuery(className: "Restaurant_Menus_Catagories_Items_Options")
        query.whereKey("merchant_id", equalTo: merchantId)
        query.whereKey("menu_catagory", equalTo: menuCatagory)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects {
                        self.merchantObject = completeMerchantObject
                    }
                }

            }
        }
        
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.tagCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.tagCollectionView.backgroundColor = UIColor.clearColor()
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        self.flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        for option in optionsTags {
            var tag = Tag()
            tag.name = option
            self.tags.append(tag)
        }
        
        quantityStepCounter.wraps = true
        quantityStepCounter.autorepeat = true
        quantityStepCounter.maximumValue = 10
        
//        let sizeViewController = UIViewController()
//        let milkViewController = UIViewController()
//        let optionsViewController = UIViewController()
//        let syrupsViewController = UIViewController()
//        
//        sizeViewController.title = "Size"
//        milkViewController.title = "Milk"
//        syrupsViewController.title = "Syrups"
//        optionsViewController.title = "Options"
//        
//        
//        let viewControllers = [sizeViewController, milkViewController, syrupsViewController, optionsViewController]
//        
//        let options = PagingMenuOptions()
//        options.defaultPage = 0
//        options.menuPosition = .Bottom
//        options.menuItemMargin = 5
//        options.menuHeight = 60
//        options.menuDisplayMode = .Standard(widthMode: .Fixed(width: 100) , centerItem: false, scrollingMode: .PagingEnabled)
//        options.menuItemMode = .Underline(height: 3, color: UIColor.blueColor(), horizontalPadding: 0, verticalPadding: 0)
//        options.menuPosition = .Bottom
//        
//        
//        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
//        pagingMenuController.view.frame.origin.y += 64
//        pagingMenuController.view.frame.size.height -= 64
//        
//        addChildViewController(pagingMenuController)
//        view.addSubview(pagingMenuController.view)
//        pagingMenuController.didMoveToParentViewController(self)
//        
//        pagingMenuController.delegate = self
        
    }
    
    //MARK: - PagingMenuControllerDelegate
    func didMoveToMenuPage(page: Int) {
        if page == 1 {
            print("test")
        }
    }

    //MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = tagCollectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
        self.configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        tagCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
        tags[indexPath.row].selected = !tags[indexPath.row].selected
        
        self.tagCollectionView.reloadData()
        
        let tag = tags[indexPath.row]
        self.orderOptions.append(tag.name!)
        
        
        self.selectedTags.append(tag.name!)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]
        
        self.orderOptions.popLast()
    }
    

    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]
        cell.tagName.text = tag.name
        cell.tagName.textColor = tag.selected ? UIColor.whiteColor(): UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        cell.backgroundColor = tag.selected ? UIColor(red: 0, green: 1, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.configureCell(self.sizingCell!, forIndexPath: indexPath)
        return self.sizingCell!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
    
    
    
   override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        //Dismiss view & go back to homescreen
        //Save options as array, along with userID, merchantID, merchantCatagory, and itemName.
        let options = PFObject(className: "Order_Options")
        options["user"] = PFUser.currentUser()
        options["restaurant_id"] = merchantId
        options["catagory_id"] = menuCatagory
        options["item_name"] = itemName
        options["options_array"] = orderOptions
        options["quantity"] = quantityTextView.text
        options["merchant"] = PFObject(withoutDataWithClassName: "Restaurants_Menus", objectId: merchantObjectId)
        
        options.saveInBackgroundWithBlock { (succeeded: Bool?, error: NSError?) -> Void in
            if succeeded == true {
                let alert = UIAlertController(title: "Success", message: "Enjoy", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func stepperValueChange(sender: UIStepper) {
        quantityTextView.text = Int(sender.value).description
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: FlowLayout!
    
    @IBOutlet weak var quantityTextView: UITextView!
    @IBOutlet weak var quantityStepCounter: UIStepper!
    
    @IBOutlet weak var pagingMenuContainer: UIView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tagContainerView: UIView!
}

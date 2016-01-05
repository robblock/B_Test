//
//  PopoverViewController.swift
//  beacons_test
//
//  Created by Rob Block on 12/10/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse
import Bond

enum OptionSection {
    case First
    case Second
    case Third
    case Fourth
}

class PopoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate{

    //TODO: Create A Xib for SelectedCollectionView
    
    var merchantId = String()
    var menuCatagory = String()
    var itemName = String()
    var merchantObjectId = String()
    var price = Double()
    
    var optionSection: OptionSection = .First
    var merchantObject = [PFObject]()
    
    var sizingCell: TagCell?
    
    var tags = [Tag]()
    var selectedTag = ObservableArray([SelectedTag]())
    
    var optionsTags = ["Skim milk", "2% Milk", "Whole Milk", "Almond Milk", "Soy Milk", "Extra Shot", "Chocolate Syrup"]
    var testArray = [String]()
    
    //Array used to save options to parse
    var orderOptions = ObservableArray([String]())
    
    //Array used to store selected tags for the entire order
    var selectedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemPriceLabel.text = ("$\(price)")
        
        orderOptions.observe { (tag) -> Void in
            print(tag)
        }
        print(merchantId)
        print(menuCatagory)
        print(itemName)
        
        let query = PFQuery(className: "Restaurants_Menus_Catagories_Items_Options")
//        query.whereKey("merchant_id", equalTo: merchantId)
//        query.whereKey("menu_catagory", equalTo: menuCatagory)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    if let completeMerchantObject = objects {
                        self.merchantObject = completeMerchantObject
                        let test = object.objectForKey("options") as! [String]
                        for option in test {
                            var tag = Tag()
                            tag.name = option
                            self.tags.append(tag)
                        }
                    }
                }
                self.tagCollectionView.reloadData()
            }
        }
        
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.tagCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "TagCell")
        
        let selectedCelllNib = UINib(nibName: "TagCell", bundle: nil)
        self.selectedOptionsCollectionView.registerNib(selectedCelllNib, forCellWithReuseIdentifier: "Selected")
        
        self.tagCollectionView.backgroundColor = UIColor.clearColor()
        self.selectedOptionsCollectionView.backgroundColor = UIColor.clearColor()
        
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        self.sizingCell = (selectedCelllNib.instantiateWithOwner(nil, options: nil) as NSArray).firstObject as! TagCell?
        self.flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        
        quantityStepCounter.wraps = true
        quantityStepCounter.autorepeat = true
        quantityStepCounter.maximumValue = 10
        
        optionsSegmenetController.selectedSegmentIndex = 0
        
        
    }


    
    //MARK: - Segment Controller
        func segmentTitle(segment: Int) -> String {
        title = ""
        
        
        
        return title!
    }
    
    func updatePrice(price: Double, var newPrice: Double) {
        newPrice = 0.00
        
    }

    //MARK: - CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
           return tags.count
        } else {
            return orderOptions.count
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            var cell = tagCollectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
            self.configureCell(cell, forIndexPath: indexPath)
            return cell
        } else {
            var cell = selectedOptionsCollectionView.dequeueReusableCellWithReuseIdentifier("Selected", forIndexPath: indexPath) as! TagCell
            
            self.configureCell2(cell, forIndexPath: indexPath)
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == tagCollectionView {
            
            tagCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
            tags[indexPath.row].selected = !tags[indexPath.row].selected
            
            self.selectedOptionsCollectionView.reloadData()
            self.tagCollectionView.reloadData()
            
            let tag = tags[indexPath.row]
            self.orderOptions.append(tag.name)
            
            
            self.selectedTag.removeAll()
            
            for selected in orderOptions {
                let tag = SelectedTag()
                tag.name = selected
                self.selectedTag.append(tag)
            }
            
        } else {
            orderOptions.removeLast()
            selectedTag.removeLast()
            self.tagCollectionView.reloadData()
            self.selectedOptionsCollectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]
        if collectionView == tagCollectionView {
            
        orderOptions.removeLast()
        }
    }
    

    
    func configureCell(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        
        switch optionSection {
        case .First:
            let tag = tags[indexPath.row]
            cell.tagName.text = tag.name
            cell.tagName.textColor = tag.selected ? UIColor.whiteColor(): UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
            cell.backgroundColor = tag.selected ? UIColor(red: 0, green: 1, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        default: break
        }
        
    }
    
    func configureCell2(cell: TagCell, forIndexPath indexPath: NSIndexPath) {
        let tag = selectedTag[indexPath.row]
        cell.tagName.text = tag.name

        for (index, element) in selectedTag.enumerate() {
            print("Item \(index): \(element.name)")
        }
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            self.configureCell(self.sizingCell!, forIndexPath: indexPath)
            return self.sizingCell!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            self.configureCell2(self.sizingCell!, forIndexPath: indexPath)
            return self.sizingCell!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            
        }
    }
    
    
    
   override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    func customizeButton(button: UIButton) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //MARK: - Actions & Outlets
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
    
    
    @IBAction func optionsCatagoriesSegmentedControl(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            optionSection = .First
        } else if sender.selectedSegmentIndex == 1 {
            optionSection = .Second
        } else if sender.selectedSegmentIndex == 2 {
            optionSection = .Third
        } else if sender.selectedSegmentIndex == 3 {
            optionSection = .Fourth
        }
        tagCollectionView.reloadData()
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var tagView: UIView!
    
    @IBOutlet weak var optionsSegmenetController: UISegmentedControl!
    @IBOutlet weak var selectedOptionsCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    
    @IBOutlet weak var flowLayout: FlowLayout!
    
    @IBOutlet weak var quantityTextView: UITextView!
    @IBOutlet weak var quantityStepCounter: UIStepper!

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var pagingMenuContainer: UIView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tagContainerView: UIView!
}
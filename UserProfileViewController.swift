//
//  UserProfileViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse

struct Data {
    var FirstName:String!
    var LastName:String!
    var Gender:String!
    var Age:String!
    var Image:UIImage!
}


class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var preferedDrink = [String]()
    var previousDrink = [String]()
    
    let parseHelper = ParseHelper()
    var usersData = [Data]()
    
    
    @IBOutlet var UsersInfoTextFields: [UITextField]!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveToParseButton: UIButton!
    @IBOutlet weak var imagePickerButton: UIButton!

    
    @IBOutlet weak var usersFirstNameField: UITextField!
    @IBOutlet weak var usersLastNameField: UITextField!
    @IBOutlet weak var usersAgeField: UITextField!
    @IBOutlet weak var usersGenderField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var submitUserInfoButton: UIButton!
    
    @IBOutlet weak var editViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageView.image == nil {
            let usersImage = PFUser.currentUser()?.objectForKey("userImage") as! PFFile
            usersImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }
            })
        }
        
//        var userData:Data!
//        
//        parseUsersData { (usersDataArray) -> Void in
//            self.usersData = usersDataArray
//        }

                
        usersFirstNameField.delegate = self
        usersLastNameField.delegate = self
        usersAgeField.delegate = self
        usersGenderField.delegate = self
        
        //applyPlaceholderStyle(usersFirstNameField, placeholderText: "First Name")
        applyPlaceholderStyle(usersLastNameField, placeholderText: "Last Name")
        applyPlaceholderStyle(usersAgeField, placeholderText: "Age")
        applyPlaceholderStyle(usersGenderField, placeholderText: "Gender")
        
        usersFirstNameField.borderStyle = UITextBorderStyle.None
        usersLastNameField.borderStyle = UITextBorderStyle.None
        usersAgeField.borderStyle = UITextBorderStyle.None
        usersGenderField.borderStyle = UITextBorderStyle.None
        
    }
    
    
    func parseUsersData(completionHandler: [Data] -> Void) {
        var usersDataArray = [Data]()
        let query = PFQuery(className: "_User")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let user = objects as? [PFObject]! {
                    for object in user! {
                        var singleData = Data()
                        singleData.FirstName = object["firstName"] as! String
                        singleData.LastName = object["lastName"] as! String
                        singleData.Gender = object["gender"] as! String
                        singleData.Age = object["age"] as! String
                        var image = object["userImage"] as! PFFile
                        image.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    singleData.Image = UIImage(data: imageData)
                                    usersDataArray.append(singleData)
                                    
                                }
                            }
                        })
                        
                        usersDataArray.append(singleData)
                    }
                    self.tableView.reloadData()
                }
                
                completionHandler(usersDataArray)
            }
            
        }
    }
    
    
    func performQuery() {
        let query = PFQuery(className: "_User")
        query.whereKey("User", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) lighthouses.")
                // Do something with the found objects
                if let light = objects as? [PFObject]? {
                    for object in light! {
                        _ = Data()
                        let firstName = object["firstName"] as! String
                        let lastName = object["lastName"] as! String
                        let gender = object["gender"] as! String
                        let age = object["age"] as! String
                        
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        //Style View
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        
        let tab = UITabBar.appearance()
        tab.barStyle = UIBarStyle.Black
    }

                    
    //MARK: - Profile Image
    //We can potentially send the image to the counter with the order so they know who the order is for.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = pickedImage
        
        
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(300, 200))
        let imageData = scaledImage.lowestQualityJPEGNSData
        let imageFile:PFFile = PFFile(data: imageData)!
        
        
        PFUser.currentUser()!.setObject(imageFile, forKey: "userImage")
        PFUser.currentUser()?.saveInBackground()

        PFUser.currentUser()?.pinInBackgroundWithName("userImage")
        
        imagePickerButton.hidden = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imagePickerButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func scaleImageWith(newImage:UIImage, and newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        newImage.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //MARK: - Users Information
    func setUserInfo() {
        PFUser.currentUser()?.setObject(usersFirstNameField.text!, forKey: "firstName")
        PFUser.currentUser()?.setObject(usersLastNameField.text!, forKey: "lastName")
        PFUser.currentUser()?.setObject(usersAgeField.text!, forKey: "age")
        PFUser.currentUser()?.setObject(usersGenderField.text!, forKey: "gender")
        
        PFUser.currentUser()?.pinInBackground()
        PFUser.currentUser()?.saveInBackground()
        
    }
    
    @IBAction func saveUsersInfo(sender: AnyObject) {
        setUserInfo()
        
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.text == nil {
            textField.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == UIColor.lightGrayColor() {
            textField.textColor = UIColor.blackColor()
            textField.text?.uppercaseString
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == nil {
            textField.textColor = UIColor.lightGrayColor()
        } else {
            textField.textColor = UIColor.blackColor()
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if textField.text == UIColor.lightGrayColor() {
            
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.utf16.count)! - range.length
        if newLength > 0 {
            
        }
        
        return true
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
    //Tap outside textField to dismiss keyboard
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func saveTextFieldsToParse() -> UITextField? {
        for field in UsersInfoTextFields {
            if field.textColor == UIColor.blackColor() {
                return field
            }
        }
        return nil
    }
    
    func applyPlaceholderStyle(aTextview: UITextField, placeholderText: String) {
        aTextview.textColor = UIColor.lightGrayColor()
        aTextview.text = placeholderText

    }
    
    func applyNonPlaceHolderStyle(aTextView: UITextField) {
        aTextView.textColor = UIColor.blackColor()
        aTextView.alpha = 1.0
    }
    
    //MARK: - TableView DataSource & Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case(0, 0):
            cell.textLabel!.text = "Prefered Order"
        case(0, 1):
            cell.textLabel!.text = "Previous Order"
        case(1,1):
            cell.textLabel!.text = "Payment Preferences"
            
        case(1,2):
            cell.textLabel!.text = "Suport"
        default:
            cell.textLabel!.text = ""
        
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case(0, 0):
            performSegueWithIdentifier("preferred", sender: self)
        case(0, 1):
            performSegueWithIdentifier("previous", sender: self)
        case(1,1):
            performSegueWithIdentifier("payment", sender: self)
           
        default:
           print("test")
            
        }

//        if indexPath.row == 2 {
//            let paymentOrderView = self.storyboard?.instantiateViewControllerWithIdentifier("Payment") as PaymentChoiceViewController
//            self.presentViewController(paymentOrderView, animated: true, completion: nil)
//        }
        
    }
    
    
    //MARK: - Edit View
    
    @IBAction func editViewButton(sender: AnyObject) {
        
    }

    @IBAction func leftSideDrawerButton(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
        print("DrawerButton Tapped")
    }
}

extension UIImage {
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}

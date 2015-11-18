//
//  UserProfileViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse


class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let imagePicker = UIImagePickerController()
    
    var preferedDrink = [String]()
    var previousDrink = [String]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imagePickerButton(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    //Save users image to Parse. We can potentially send the image to the counter with the order.
    //When do I call this?
    func imageToParse() {
    
        let image = imageView.image
        let imageData = image?.lowestQualityJPEGNSData
        let imageFile = PFFile(name: "usersImage.PNG", data: imageData!)
        
        let userPhoto = PFObject(className: "UserPhoto")
        userPhoto["ImageName"] = "\(PFUser.currentUser())"
        userPhoto["imageFile"] = imageFile
        userPhoto.saveInBackground()

    }

    @IBAction func saveToParseButton(sender: AnyObject) {
        imageToParse()
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
        default:
            cell.textLabel!.text = "😵😵😵😵😵😵"
        
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let preferredOrderView = self.storyboard?.instantiateViewControllerWithIdentifier("PreferredOrder") as! PreferredOrderTableViewController
            self.presentViewController(preferredOrderView, animated: true, completion: nil)
        }
        if indexPath.row == 1 {
            let previousOrderView = self.storyboard?.instantiateViewControllerWithIdentifier("PreviousOrder") as! PreviousOrderTableViewController
            self.presentViewController(previousOrderView, animated: true, completion: nil)
        }
        
        //PaymentOptionsViewController
    }
    
    

}

extension UIImage {
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
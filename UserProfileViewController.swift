//
//  UserProfileViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var preferedOrderCell: UITableViewCell!
    @IBOutlet weak var previousOrdersCell: UITableViewCell!
    
    @IBOutlet weak var preferedOrderLabel: UILabel!
    @IBOutlet weak var previousOrderLabel: UILabel!
    
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
    func imageToParse(file: PFFile) {
        var image = imageView.image
        var data:NSData = UIImagePNGRepresentation(image!)!
        
        let file = PFFile(name: "UsersImage", data: data)
        file?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                self.imageToParse(file!)
            } else if let error = error {
                print("Error Uploading Users Photo")
            }
            },
            progressBlock: { percent in
                print("Uploaded: \(percent)%")
        })
    }

    func preferedOrderSegue() {
        
    }

    
    
}

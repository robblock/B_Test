//
//  ParseHelper.swift
//  beacons_test
//
//  Created by Rob Block on 11/19/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import Parse

class ParseHelper: NSObject {
    
    
    var currentUser = PFUser.currentUser()
    
    //Like Relation
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let parseLikeFromUser = "fromUser"
    
    //Flagged Content
    static let ParseFlaggedContentClass = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost = "toPost"
    
    //User Relation
    static let ParseUserUsername = "Username"
    
    
    static func likePost(user: PFUser, merchant: Merchant) {
        let likedObject = PFObject(className: ParseLikeClass)
        likedObject[parseLikeFromUser] = user
        //likedObject[ParseLikeToPost] = merchant
        likedObject["ParseLikeToPost"] = PFObject(withoutDataWithClassName: "Restaurants_Menus", objectId: "yfEUVsa61X")
        
        likedObject.saveInBackgroundWithBlock(nil)
    }
    
    func saveLike(user: PFUser, objectID: String) {
        let likedObject = PFObject(className: "Like")
        likedObject["fromUser"] = PFUser.currentUser()
        likedObject["toPost"] = PFObject(withoutDataWithClassName: "Restaurants_Menus", objectId: objectID)
        
        likedObject.saveInBackground()
    }
    
    func unlike(user: PFUser, objectID: String ) {
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toPost", equalTo: PFObject(withoutDataWithClassName: "Restaurants_Menus", objectId: objectID))
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results {
                for likes in results {
                    likes.deleteInBackground()
                }
            }
        }
    }
    
    static func unlikePost(user: PFUser, merchant: Merchant) {
        // 1
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(parseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo: merchant)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            // 2
            if let results = results {
                for likes in results {
                    likes.deleteInBackground()
                }
            }
        }
    }
    
    static func likesForPost(merchant: Merchant, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToPost, equalTo: merchant)
        query.includeKey(parseLikeFromUser)
        
        query.findObjectsInBackground()
    }
    
    
    
    /**
     Saves object to a specific class on Parse server
     */
    
    func saveObject(className:String, parameters:[String:AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        let objectClass = PFObject(className: className)
        
        if parameters != nil {
            for parameter in parameters! {
                objectClass[parameter.0] = parameter.1
            }
        }
        
        objectClass.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
     Retrieves objects from a specific class on Parse server
     */
    
    func retrievesObject(className:String, objectID:String?, parameters:[String:AnyObject]?, completion:(success:Bool, errorMesssage:String?, object:[AnyObject]?)->Void) {
        let query = PFQuery(className:className)
        
        if parameters != nil {
            for parameter in parameters! {
                query.whereKey(parameter.0, equalTo: parameter.1)
            }
        }
        
        if objectID != nil {
            query.getObjectInBackgroundWithId(objectID!, block: { (object, error) -> Void in
                if error == nil {
                    completion(success: true, errorMesssage: nil, object: [object as! AnyObject])
                } else {
                    completion(success: false, errorMesssage: getErrorMessage(error), object: nil)
                }
            })
        } else {
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    completion(success: true, errorMesssage: nil, object: objects)
                } else {
                    completion(success: false, errorMesssage: getErrorMessage(error), object: nil)
                }
                
            })
        }
    }
    
    /**
     Deletes object from Parse server
     */
    
    func deleteObject(object:PFObject, parameters:[String]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        if parameters == nil {
            object.deleteInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, errorMesssage: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, errorMesssage: getErrorMessage(error))
                    }
                }
            }
        } else {
            for key in parameters! {
                object.removeObjectForKey(key)
            }
            
            object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, errorMesssage: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, errorMesssage: getErrorMessage(error))
                    }
                }
            })
        }
    }
    
    /**
     Convert UIImage to PFFile so you can save it in Parse
     */
    
    func imageToPFFile(image:UIImage, withName name:String?) -> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0)!
        let imageFile: PFFile!
        if name != nil {
            imageFile = PFFile(name:name, data:imageData)
        } else {
            imageFile = PFFile(data: imageData)
        }
        return imageFile
    }
    
    func getUsersProfilePicture(completion: (UIImage, NSError)) -> UIImage {
        let usersImage = PFUser.currentUser()?.objectForKey("userImage") as! PFFile
        var image: UIImage!
        usersImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    image = UIImage(data: imageData)!
                }
            }
            
        })
        
        return image
    }
    
    

    func reverseGeocodeLocation(location:CLLocation,completion:(placemark:CLPlacemark?, error:NSError?)->Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let err = error{
                print("Error Reverse Geocoding Location: \(err.localizedDescription)")
                completion(placemark: nil, error: error)
                return
            }
            completion(placemark: placemarks?[0], error: nil)
            
        })
    }
    
    
    func addressFromPlacemark(placemark:CLPlacemark)->String{
        var address = ""
        let name = placemark.addressDictionary?["Name"] as? String
        let city = placemark.addressDictionary?["City"] as? String
        let state = placemark.addressDictionary?["State"] as? String
        let country = placemark.country
        
        if name != nil{
            address = constructAddressString(address, newString: name!)
        }
        if city != nil{
            address = constructAddressString(address, newString: city!)
        }
        if state != nil{
            address = constructAddressString(address, newString: state!)
        }
        if country != nil{
            address = constructAddressString(address, newString: country!)
        }
        return address
    }
    
    func constructAddressString(string:String, newString:String)->String{
        var address = string
        if !address.isEmpty{
            address = address.stringByAppendingString(", \(newString)")
        }
        else{
            address = address.stringByAppendingString(newString)
        }
        return address
    }

}






 func getErrorMessage(error:NSError?) -> String {
    var errorMessage = ""
    if error != nil {
        errorMessage = error!.localizedDescription
        errorMessage.replaceRange(errorMessage.startIndex...errorMessage.startIndex, with: String(errorMessage[errorMessage.startIndex]).capitalizedString)
    } else {
        errorMessage = "Unexpected error occured. Please try again"
    }
    return errorMessage
}


    

class ExtendedNavBarView: UIView {
    
    //| ----------------------------------------------------------------------------
    //  Called when the view is about to be displayed.  May be called more than
    //  once.
    //
    override func willMoveToWindow(newWindow: UIWindow?) {
        // Use the layer shadow to draw a one pixel hairline under this view.
        self.layer.shadowOffset = CGSizeMake(0, 1.0/UIScreen.mainScreen().scale)
        self.layer.shadowRadius = 0
        
        // UINavigationBar's hairline is adaptive, its properties change with
        // the contents it overlies.  You may need to experiment with these
        // values to best match your content.
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.25
        
    }
    
}

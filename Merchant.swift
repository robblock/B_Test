//
//  Merchant.swift
//  beacons_test
//
//  Created by Rob Block on 11/12/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import Parse
import Bond

class Merchant: PFObject, PFSubclassing {
    
    @NSManaged var restaurant_id: String?
    @NSManaged var user: PFUser?
    @NSManaged var Location: PFGeoPoint?
    @NSManaged var objectiD: String?
    
     var likes =  Observable<[PFUser]?>(nil)
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Restaurants_Menus"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    //Should the like button be red or grey
    func doesUserLikeMerchant(user: PFUser) -> Bool {
        if let likes = likes.value {
            return likes.contains(user)
        } else {
            return false
        }
    }

    func toggleLikePost(user: PFUser) {
        if (doesUserLikeMerchant(user)) {
            // if image is liked, unlike it now
            // 1
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, merchant: self)
        } else {
            // if this image is not liked yet, like it now
            // 2
            likes.value?.append(user)
            ParseHelper.likePost(user, merchant: self)
        }
    }
    
    func fetchLikes() {
        if (likes.value != nil) {
            print("NoLikes")
            return
        }
        
        ParseHelper.likesForPost(self, completionBlock: { (var likes: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            // filter likes that are from users that no longer exist
            likes = likes?.filter { like in like[ParseHelper.parseLikeFromUser] != nil }
            
            self.likes.value = likes?.map { like in
                let like = like as! PFObject
                let fromUser = like[ParseHelper.parseLikeFromUser] as! PFUser
                
                return fromUser
            }
        })
    }
    
    
}
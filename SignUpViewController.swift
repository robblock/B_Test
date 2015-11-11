//
//  SignUpViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import ParseUI

/*
    What information do we want the user to provide when signing up?
        --> If we only want to take the users email & password, use this view controller.
            } else {
        --> If we want to add additional fields, such as: name, age, etc. I need to make a new view controller.
*/


class SignUpViewController : PFSignUpViewController {
    
    var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(image: UIImage(named: "welcome_bg"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.signUpView?.insertSubview(backgroundImage, atIndex: 0)
        
        let logo = UILabel()
        logo.text = "ORDR"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        signUpView?.logo = logo
        
        signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        signUpView?.signUpButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        
        signUpView?.dismissButton?.setTitle("Already Signed Up?", forState: .Normal)
        signUpView?.dismissButton?.setImage(nil, forState: .Normal)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        //Customize Button
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let signUpViewController = SignUpViewController()
        signUpView?.delegate = self
        signUpViewController.fields = PFSignUpFields(rawValue: PFSignUpFields.UsernameAndPassword.rawValue | PFSignUpFields.Email.rawValue | PFSignUpFields.SignUpButton.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImage.frame = CGRectMake(0, 0, self.signUpView!.frame.width, self.signUpView!.frame.height)
        
        //Position the logo at the top with larger frame
        signUpView?.logo?.sizeToFit()
        let logoFrame = signUpView?.logo?.frame
        signUpView?.logo?.frame = CGRectMake(logoFrame!.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame!.height - 16, signUpView!.frame.width, logoFrame!.height)
        
        //Re-Layout dismiss button to be below sign
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton?.frame = CGRectMake(0, signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0, signUpView!.frame.width, dismissButtonFrame.height)
    }
    
}

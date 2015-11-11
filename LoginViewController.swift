//
//  LoginViewController.swift
//  beacons_test
//
//  Created by Rob Block on 11/11/15.
//  Copyright © 2015 robblock. All rights reserved.
//

import Foundation
import ParseUI

class LoginViewController : PFLogInViewController {
    
    var backgroundImage: UIImageView!
//    var viewsToAnimate: [UIView!]!
//    var viewsFinalPosition = [CGFloat]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the background image
        backgroundImage = UIImageView(image: UIImage(named: "welcome_bg"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView?.insertSubview(backgroundImage, atIndex: 0)
        
        //Remove the Parse Logo
        let logo = UILabel()
        logo.text = "ORDR"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        logInView?.logo = logo
        
        //Set forgotten password button to white
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        //Make the background of the loggin button pop more
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        
        //Make the buttons classier
//        customizeButton(logInView!.facebookButton!)
//        customizeButton(logInView!.twitterButton!)
//        customizeButton(logInView!.signUpButton!)
        
        self.signUpController = SignUpViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Stretch background image to fill screen
        backgroundImage.frame = CGRectMake(0, 0, self.logInView!.frame.width, self.logInView!.frame.height)
        
        logInView?.logo?.sizeToFit()
        let logoFrame = logInView?.logo?.frame
        logInView?.logo!.frame = CGRectMake(logoFrame!.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame!.height - 16, logInView!.frame.width, logoFrame!.height)
    }
    
    func customizeButton(button: UIButton) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
}